using Microsoft.AspNetCore.Mvc;
using System.Collections.Concurrent;

namespace IntegrationAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class WorkController : ControllerBase
    {
        private readonly MessageService _messageService;
        private readonly ILogger<WorkController> _logger;
        private static readonly ConcurrentDictionary<string, WorkItem> _processedItems = 
            new ConcurrentDictionary<string, WorkItem>();

        public WorkController(MessageService messageService, ILogger<WorkController> logger)
        {
            _messageService = messageService;
            _logger = logger;
        }

        /// <summary>
        /// POST /api/work - Submit a work item to be processed asynchronously
        /// </summary>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status202Accepted)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> SubmitWork([FromBody] WorkRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Title))
            {
                _logger.LogWarning("Invalid work request received");
                return BadRequest(new { error = "Title is required" });
            }

            try
            {
                var workId = Guid.NewGuid().ToString();
                var workItem = new WorkItem
                {
                    WorkId = workId,
                    Title = request.Title,
                    Data = request.Data,
                    Status = "queued",
                    CreatedAt = DateTime.UtcNow
                };

                // Send to Service Bus
                await _messageService.SendMessageAsync(workItem);

                // Store locally for tracking
                _processedItems.TryAdd(workId, workItem);

                _logger.LogInformation($"Work item {workId} queued successfully");

                return Accepted(new
                {
                    workId = workId,
                    status = "queued",
                    createdAt = workItem.CreatedAt,
                    message = "Work item queued for processing"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error submitting work: {ex.Message}");
                return StatusCode(500, new { error = "Queue operation failed" });
            }
        }

        /// <summary>
        /// GET /api/work - Retrieve list of processed work items
        /// </summary>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public IActionResult GetWorkItems([FromQuery] string? status = null, 
                                         [FromQuery] int limit = 100, 
                                         [FromQuery] int offset = 0)
        {
            try
            {
                var items = _processedItems.Values.AsEnumerable();

                // Filter by status if provided
                if (!string.IsNullOrWhiteSpace(status))
                {
                    items = items.Where(w => w.Status.Equals(status, StringComparison.OrdinalIgnoreCase));
                }

                // Apply pagination
                items = items.Skip(offset).Take(limit);

                _logger.LogInformation($"Retrieved {items.Count()} work items");

                return Ok(new
                {
                    items = items.Select(w => new
                    {
                        workId = w.WorkId,
                        status = w.Status,
                        title = w.Title,
                        createdAt = w.CreatedAt,
                        completedAt = w.CompletedAt,
                        result = w.Result
                    }),
                    count = items.Count(),
                    timestamp = DateTime.UtcNow
                });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error retrieving work items: {ex.Message}");
                return StatusCode(500, new { error = "Retrieval failed" });
            }
        }
    }
}
