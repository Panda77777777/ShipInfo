using ShipInfo.Models;
namespace ShipInfo.Services;
// Демо-данные. Для реальных данных замените методы на вызовы вашего API (AIS, новости, отзывы).
public static class DataService
{
    public static List<Ship> Ships { get; } = new()
    {
        new() { Name="PORT KYOTO", Names="PORT KYOTO", Imo="9942093", Flag="—", Lat=48.2, Lon=-6.0, Favorite=true },
        new() { Name="SARONIC SPIRIT", Names="SARONIC SPIRIT, VENTURE TEAM, XING RONG HAI", Imo="9725392", Flag="Маршалловы о-ва", Lat=49.5, Lon=-3.0 },
        new() { Name="STAR CANDY", Names="CS CANDY, STAR CANDY", Imo="9542544", Flag="Либерия", Lat=47.0, Lon=-8.0 },
        new() { Name="TIAN YI 88", Names="TIAN YI 88, MENDOCINO, CONRAD OLDENDORFF", Imo="9231298", Flag="—", Lat=50.0, Lon=-1.5 },
    };

    public static List<NewsItem> News { get; } = new()
    {
        new() { Title="Swedish owner Veritas books up to six chemical tankers in China", Text="Swedish shipowner Veritas Tankers has placed an order for up to six 13,000 dwt stainless steel chemical tankers…", Date="30.10.2026", Source="Splash247.com" },
        new() { Title="Evalend drops newcastlemax option at Dajin Heavy", Text="Опцион на newcastlemax отменён…", Date="30.10.2026", Source="Splash247.com" },
    };
    public static readonly string[] NewsSources = { "Splash247.com", "Customer Advisories", "Seafarers Journal" };

    public static List<Review> Reviews { get; } = new()
    {
        new() { Author="Моряк", Text="Хорошее судно, нормальные условия." },
    };
}
