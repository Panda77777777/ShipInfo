using ShipInfo.Models; using ShipInfo.Services;
namespace ShipInfo.Pages;
public partial class FleetPage : ContentPage
{
    public FleetPage() { InitializeComponent(); }
    protected override void OnAppearing() { base.OnAppearing(); List.SelectedItem = null; List.ItemsSource = DataService.Ships.Where(s => s.Favorite).ToList(); }
    async void OnSelected(object? s, SelectionChangedEventArgs e)
    {
        if (e.CurrentSelection.FirstOrDefault() is Ship ship)
            await Shell.Current.GoToAsync("ship", new Dictionary<string, object> { ["Ship"] = ship });
    }
}
