Ship Info (.NET MAUI, Android)
1. Установите .NET 8 SDK + workload:  dotnet workload install maui-android
2. В Platforms/Android/AndroidManifest.xml вставьте ключ Google Maps API (Maps SDK for Android).
3. Запуск:  dotnet build -t:Run -f net8.0-android
   Или откройте ShipInfo.csproj в Visual Studio 2022 -> Run.
Данные демо: Services/DataService.cs — замените на ваш API.
