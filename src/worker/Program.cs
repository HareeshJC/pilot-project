using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Azure.Messaging.ServiceBus;
using Azure.Identity;

var builder = Host.CreateDefaultBuilder(args);

builder.ConfigureServices(services =>
{
    // Add Application Insights
    services.AddApplicationInsightsTelemetryWorkerService();

    // Configure logging
    services.AddLogging(config =>
    {
        config.AddConsole();
    });

    // Register worker service
    services.AddHostedService<WorkerService>();

    // Configure Service Bus client
    services.AddSingleton(sp =>
    {
        var configuration = sp.GetRequiredService<IConfiguration>();
        var connectionString = configuration.GetConnectionString("ServiceBusConnection");
        return new ServiceBusClient(connectionString);
    });

    // Add configuration
    services.AddSingleton<IConfiguration>(
        new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", optional: false)
            .AddEnvironmentVariables()
            .Build()
    );
});

builder.ConfigureLogging(config =>
{
    config.AddConsole();
});

var host = builder.Build();
host.Run();
