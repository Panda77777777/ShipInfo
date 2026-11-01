using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
namespace ShipInfo.Services;

public class Vessel
{
    public long Mmsi { get; set; }
    public string Name { get; set; } = "";
    public double Lat { get; set; }
    public double Lon { get; set; }
    public DateTime Updated { get; set; }
}

public static class AisService
{
    static readonly Dictionary<long, Vessel> vessels = new();
    static readonly object gate = new();
    static CancellationTokenSource? cts;
    public static string Status = "не запущено";

    public static List<Vessel> Snapshot()
    {
        lock (gate) return vessels.Values.OrderByDescending(v => v.Updated).Take(300).ToList();
    }

    public static void Start(double minLat, double minLon, double maxLat, double maxLon)
    {
        cts?.Cancel();
        lock (gate) vessels.Clear();
        cts = new CancellationTokenSource();
        var token = cts.Token;
        _ = Task.Run(() => Run(minLat, minLon, maxLat, maxLon, token));
    }

    static async Task Run(double minLat, double minLon, double maxLat, double maxLon, CancellationToken token)
    {
        string key = Secrets.AisKey;
        if (string.IsNullOrWhiteSpace(key)) { Status = "нет ключа"; return; }
        while (!token.IsCancellationRequested)
        {
            try
            {
                using var ws = new ClientWebSocket();
                Status = "подключение";
                await ws.ConnectAsync(new Uri("wss://stream.aisstream.io/v0/stream"), token);
                var sub = JsonSerializer.Serialize(new
                {
                    APIKey = key,
                    BoundingBoxes = new[] { new[] { new[] { minLat, minLon }, new[] { maxLat, maxLon } } },
                    FilterMessageTypes = new[] { "PositionReport" }
                });
                await ws.SendAsync(new ArraySegment<byte>(Encoding.UTF8.GetBytes(sub)), WebSocketMessageType.Text, true, token);
                Status = "подключено";
                var buf = new byte[16384];
                while (ws.State == WebSocketState.Open && !token.IsCancellationRequested)
                {
                    using var ms = new MemoryStream();
                    WebSocketReceiveResult r;
                    do
                    {
                        r = await ws.ReceiveAsync(new ArraySegment<byte>(buf), token);
                        if (r.MessageType == WebSocketMessageType.Close) break;
                        ms.Write(buf, 0, r.Count);
                    } while (!r.EndOfMessage);
                    if (r.MessageType == WebSocketMessageType.Close) break;
                    Parse(Encoding.UTF8.GetString(ms.ToArray()));
                }
            }
            catch (OperationCanceledException) { }
            catch (Exception ex) { Status = "ошибка: " + ex.Message; }
            try { await Task.Delay(5000, token); } catch { }
        }
    }

    static void Parse(string json)
    {
        try
        {
            using var doc = JsonDocument.Parse(json);
            var root = doc.RootElement;
            if (root.TryGetProperty("error", out var err)) { Status = "ошибка: " + err.ToString(); return; }
            if (!root.TryGetProperty("MessageType", out var mt) || mt.GetString() != "PositionReport") return;
            var meta = root.GetProperty("MetaData");
            var pr = root.GetProperty("Message").GetProperty("PositionReport");
            long mmsi = meta.GetProperty("MMSI").GetInt64();
            string name = meta.TryGetProperty("ShipName", out var n) ? (n.GetString() ?? "").Trim() : "";
            double lat = pr.GetProperty("Latitude").GetDouble();
            double lon = pr.GetProperty("Longitude").GetDouble();
            lock (gate)
            {
                vessels[mmsi] = new Vessel { Mmsi = mmsi, Name = name, Lat = lat, Lon = lon, Updated = DateTime.UtcNow };
                if (vessels.Count > 1500)
                {
                    var old = vessels.Values.OrderBy(v => v.Updated).Take(500).Select(v => v.Mmsi).ToList();
                    foreach (var k in old) vessels.Remove(k);
                }
            }
        }
        catch { }
    }
}
