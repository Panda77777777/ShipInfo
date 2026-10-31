using ShipInfo.Services;
namespace ShipInfo.Pages;
public partial class NewsPage : ContentPage
{
    readonly HashSet<string> enabled = new(DataService.NewsSources);
    public NewsPage() { InitializeComponent(); Refresh(); }
    void Refresh() => List.ItemsSource = DataService.News.Where(n => enabled.Contains(n.Source)).ToList();
    async void OnSources(object? s, EventArgs e)
    {
        // по очереди переключаем источник
        var choice = await DisplayActionSheet("Источник (вкл/выкл)", "Закрыть", null,
            DataService.NewsSources.Select(x => (enabled.Contains(x) ? "✔ " : "✖ ") + x).ToArray());
        if (choice == null || choice == "Закрыть") return;
        var name = choice[2..];
        if (!enabled.Remove(name)) enabled.Add(name);
        Refresh();
    }
}
