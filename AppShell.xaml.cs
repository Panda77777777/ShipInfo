using ShipInfo.Pages;
namespace ShipInfo;
public partial class AppShell : Shell
{
    public AppShell() { InitializeComponent(); Routing.RegisterRoute("ship", typeof(ShipDetailPage)); }
}
