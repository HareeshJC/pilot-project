namespace IntegrationAPI.Controllers
{
    public class WorkItem
    {
        public string WorkId { get; set; }
        public string Title { get; set; }
        public Dictionary<string, object>? Data { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? CompletedAt { get; set; }
        public Dictionary<string, object>? Result { get; set; }
    }

    public class WorkRequest
    {
        public string Title { get; set; }
        public Dictionary<string, object>? Data { get; set; }
    }

    public class HealthCheckResponse
    {
        public string Status { get; set; }
        public DateTime Timestamp { get; set; }
        public string Service { get; set; }
        public string? Error { get; set; }
    }

    public class ReadinessCheckResponse
    {
        public string Status { get; set; }
        public Dictionary<string, string> Dependencies { get; set; }
        public DateTime Timestamp { get; set; }
        public string? Error { get; set; }
    }
}
