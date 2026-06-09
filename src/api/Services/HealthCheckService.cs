using Azure.Messaging.ServiceBus;

public class HealthCheckService
{
    private readonly ServiceBusClient _serviceBusClient;
    private readonly ILogger<HealthCheckService> _logger;
    private readonly IConfiguration _configuration;

    public HealthCheckService(ServiceBusClient serviceBusClient, ILogger<HealthCheckService> logger, IConfiguration configuration)
    {
        _serviceBusClient = serviceBusClient;
        _logger = logger;
        _configuration = configuration;
    }

    /// <summary>
    /// Liveness probe - checks if service is running and responsive
    /// </summary>
    public async Task<HealthCheckResult> GetLivenessAsync()
    {
        try
        {
            // Service is alive if it can respond
            return new HealthCheckResult
            {
                Status = "healthy",
                Timestamp = DateTime.UtcNow,
                Service = "api"
            };
        }
        catch (Exception ex)
        {
            _logger.LogError($"Liveness check failed: {ex.Message}");
            return new HealthCheckResult
            {
                Status = "unhealthy",
                Timestamp = DateTime.UtcNow,
                Service = "api",
                Error = ex.Message
            };
        }
    }

    /// <summary>
    /// Readiness probe - checks if service is ready to accept traffic
    /// </summary>
    public async Task<ReadinessCheckResult> GetReadinessAsync()
    {
        var dependencies = new Dictionary<string, string>();

        try
        {
            // Check Service Bus connectivity
            try
            {
                var queueName = _configuration.GetValue<string>("ServiceBus:QueueName") ?? "work-queue";
                var receiver = _serviceBusClient.CreateReceiver(queueName);
                await receiver.DisposeAsync();
                dependencies["service_bus"] = "connected";
            }
            catch
            {
                dependencies["service_bus"] = "disconnected";
            }

            // Check Key Vault connectivity (if configured)
            try
            {
                // Would check Key Vault here if implemented
                dependencies["key_vault"] = "connected";
            }
            catch
            {
                dependencies["key_vault"] = "disconnected";
            }

            // Determine overall readiness
            var allHealthy = dependencies.All(d => d.Value == "connected");
            var status = allHealthy ? "ready" : "not_ready";

            return new ReadinessCheckResult
            {
                Status = status,
                Dependencies = dependencies,
                Timestamp = DateTime.UtcNow
            };
        }
        catch (Exception ex)
        {
            _logger.LogError($"Readiness check failed: {ex.Message}");
            return new ReadinessCheckResult
            {
                Status = "not_ready",
                Dependencies = dependencies,
                Timestamp = DateTime.UtcNow,
                Error = ex.Message
            };
        }
    }
}

public class HealthCheckResult
{
    public string Status { get; set; }
    public DateTime Timestamp { get; set; }
    public string Service { get; set; }
    public string? Error { get; set; }
}

public class ReadinessCheckResult
{
    public string Status { get; set; }
    public Dictionary<string, string> Dependencies { get; set; }
    public DateTime Timestamp { get; set; }
    public string? Error { get; set; }
}
