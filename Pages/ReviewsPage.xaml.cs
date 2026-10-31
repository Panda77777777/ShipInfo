using System.Collections.ObjectModel; using ShipInfo.Models; using ShipInfo.Services;
namespace ShipInfo.Pages;
public partial class ReviewsPage : ContentPage
{
    readonly ObservableCollection<Review> reviews = new(DataService.Reviews);
    readonly ObservableCollection<Review> msgs = new();
    bool showReviews = true;
    public ReviewsPage() { InitializeComponent(); Refresh(); }
    void Refresh()
    {
        List.ItemsSource = showReviews ? reviews : msgs;
        TabReviews.BackgroundColor = showReviews ? Color.FromArgb("#0A5BD3") : Colors.White;
        TabReviews.TextColor = showReviews ? Colors.White : Colors.Black;
        TabMsgs.BackgroundColor = !showReviews ? Color.FromArgb("#0A5BD3") : Colors.White;
        TabMsgs.TextColor = !showReviews ? Colors.White : Colors.Black;
    }
    void OnReviews(object? s, EventArgs e) { showReviews = true; Refresh(); }
    void OnMsgs(object? s, EventArgs e) { showReviews = false; Refresh(); }
    void OnSend(object? s, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(Input.Text)) return;
        (showReviews ? reviews : msgs).Add(new Review { Author = "Вы", Text = Input.Text });
        Input.Text = "";
    }
}
