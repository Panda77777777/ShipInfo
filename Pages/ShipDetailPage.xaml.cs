using ShipInfo.Models;
namespace ShipInfo.Pages;
[QueryProperty(nameof(Ship), "Ship")]
public partial class ShipDetailPage : ContentPage
{
    Ship? ship;
    public Ship? Ship { get => ship; set { ship = value; Fill(); } }
    public ShipDetailPage() { InitializeComponent(); }
    void Fill()
    {
        if (ship == null) return;
        Title = ship.Name; NameL.Text = ship.Name; NamesL.Text = ship.Names;
        ImoL.Text = "IMO: " + ship.Imo; TypeL.Text = "Тип: " + ship.Type; FlagL.Text = "Флаг: " + ship.Flag;
        PosL.Text = $"Позиция: {ship.Lat:F3}, {ship.Lon:F3}";
        FavBtn.Text = ship.Favorite ? "★ Убрать из моего флота" : "☆ Добавить в мой флот";
    }
    void OnFav(object? s, EventArgs e) { if (ship == null) return; ship.Favorite = !ship.Favorite; Fill(); }
}
