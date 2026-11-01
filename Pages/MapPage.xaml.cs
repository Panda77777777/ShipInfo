using System.Globalization;
using System.Text.Json;
using Microsoft.Maui.Dispatching;
using ShipInfo.Services;
namespace ShipInfo.Pages;

public partial class MapPage : ContentPage
{
    IDispatcherTimer? timer;
    bool started;

    const string Html = """
<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.js"></script>
<style>html,body,#m{height:100%;margin:0}</style></head><body><div id="m"></div><script>
var map=L.map('m').setView([48.5,-4],6);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:18,attribution:'OpenStreetMap'}).addTo(map);
var mk={};
function upd(list){
  var seen={};
  list.forEach(function(v){
    seen[v.m]=1;
    if(mk[v.m]){mk[v.m].setLatLng([v.a,v.o]);}
    else{
      mk[v.m]=L.circleMarker([v.a,v.o],{radius:6,color:'#0A5BD3',fillOpacity:0.8}).addTo(map).bindPopup(v.n+' | MMSI '+v.m);
    }
  });
  for(var k in mk){if(!seen[k]){map.removeLayer(mk[k]);delete mk[k];}}
}
function bounds(){var b=map.getBounds();return b.getSouth()+','+b.getWest()+','+b.getNorth()+','+b.getEast();}
</script></body></html>
""";

    public MapPage()
    {
        InitializeComponent();
        Web.Source = new HtmlWebViewSource { Html = Html, BaseUrl = "https://shipinfo.app/" };
    }

    protected override void OnAppearing()
    {
        base.OnAppearing();
        if (!started) { started = true; AisService.Start(44, -10, 52, 3); }
        if (timer == null)
        {
            timer = Dispatcher.CreateTimer();
            timer.Interval = TimeSpan.FromSeconds(3);
            timer.Tick += async (s, e) => await Refresh();
        }
        timer.Start();
    }

    protected override void OnDisappearing()
    {
        base.OnDisappearing();
        timer?.Stop();
    }

    async Task Refresh()
    {
        var list = AisService.Snapshot()
            .Select(v => new { m = v.Mmsi, n = string.IsNullOrEmpty(v.Name) ? "?" : v.Name, a = v.Lat, o = v.Lon })
            .ToList();
        var json = JsonSerializer.Serialize(list);
        try { await Web.EvaluateJavaScriptAsync("upd(" + json + ")"); } catch { }
        Title = "Рядом: " + list.Count + " • " + AisService.Status;
    }

    async void OnArea(object? sender, EventArgs e)
    {
        try
        {
            var res = (await Web.EvaluateJavaScriptAsync("bounds()"))?.Trim('"');
            if (res == null) return;
            var p = res.Split(',').Select(x => double.Parse(x, CultureInfo.InvariantCulture)).ToArray();
            double south = p[0], west = p[1], north = p[2], east = p[3];
            double cLat = (south + north) / 2, cLon = (west + east) / 2;
            double hLat = Math.Min(north - south, 20) / 2, hLon = Math.Min(east - west, 30) / 2;
            AisService.Start(Math.Clamp(cLat - hLat, -90, 90), Math.Clamp(cLon - hLon, -180, 180),
                             Math.Clamp(cLat + hLat, -90, 90), Math.Clamp(cLon + hLon, -180, 180));
        }
        catch { }
    }
}
