namespace IntegrationWorker.Models
{
    public class WorkItem
    {
        public string WorkId { get; set; }
        public string Title { get; set; }
        public Dictionary<string, object> Data { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class ProcessingResult
    {
        public string WorkId { get; set; }
        public bool Success { get; set; }
        public string Message { get; set; }
        public Dictionary<string, object> Result { get; set; }
        public DateTime ProcessedAt { get; set; }
    }
}
