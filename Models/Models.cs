namespace ShipInfo.Models;
public class Ship
{
    public string Name { get; set; } = "";
    public string Names { get; set; } = "";
    public string Imo { get; set; } = "";
    public string Type { get; set; } = "bulk carrier";
    public string Flag { get; set; } = "";
    public double Lat { get; set; }
    public double Lon { get; set; }
    public bool Favorite { get; set; }
}
public class NewsItem
{
    public string Title { get; set; } = "";
    public string Text { get; set; } = "";
    public string Date { get; set; } = "";
    public string Source { get; set; } = "";
}
public class Review
{
    public string Author { get; set; } = "";
    public string Text { get; set; } = "";
}
