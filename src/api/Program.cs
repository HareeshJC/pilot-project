using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Azure.Messaging.ServiceBus;
using Azure.Identity;

var builder = WebApplication.CreateBuilder(args);

// Configure logging
builder.Logging.AddConsole();
builder.Logging.AddApplicationInsights();

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add Application Insights
builder.Services.AddApplicationInsightsTelemetry();

// Register custom services
builder.Services.AddSingleton<MessageService>();
builder.Services.AddSingleton<HealthCheckService>();

// Configure Service Bus client
builder.Services.AddSingleton(sp =>
{
    var connectionString = builder.Configuration.GetConnectionString("ServiceBusConnection");
    return new ServiceBusClient(connectionString);
});

// Add health checks
builder.Services.AddHealthChecks();

// Add CORS if needed
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthorization();

// Map health check endpoints
app.MapHealthChecks("/health/live");
app.MapHealthChecks("/health/ready");

// Map controllers
app.MapControllers();

app.Run();
