using Microsoft.Maui.Controls.Maps; using Microsoft.Maui.Maps; using ShipInfo.Services;
namespace ShipInfo.Pages;
public partial class MapPage : ContentPage
{
    public MapPage()
    {
        InitializeComponent();
        foreach (var s in DataService.Ships)
            Map.Pins.Add(new Pin { Label = s.Name, Address = "IMO " + s.Imo, Location = new Location(s.Lat, s.Lon) });
        Map.MoveToRegion(MapSpan.FromCenterAndRadius(new Location(48.5, -4), Distance.FromKilometers(500)));
    }
}
