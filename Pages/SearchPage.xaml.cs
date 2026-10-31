using ShipInfo.Models; using ShipInfo.Services;
namespace ShipInfo.Pages;
public partial class SearchPage : ContentPage
{
    public SearchPage() { InitializeComponent(); List.ItemsSource = DataService.Ships; }
    void OnText(object? s, TextChangedEventArgs e)
    {
        var q = (e.NewTextValue ?? "").Trim().ToLower();
        List.ItemsSource = DataService.Ships.Where(x => q == "" || x.Name.ToLower().Contains(q) || x.Names.ToLower().Contains(q) || x.Imo.Contains(q)).ToList();
    }
    async void OnSelected(object? s, SelectionChangedEventArgs e)
    {
        if (e.CurrentSelection.FirstOrDefault() is Ship ship)
        {
            List.SelectedItem = null;
            await Shell.Current.GoToAsync("ship", new Dictionary<string, object> { ["Ship"] = ship });
        }
    }
}
