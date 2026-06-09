using Azure.Messaging.ServiceBus;
using System.Text.Json;
using System.Diagnostics;
using IntegrationWorker.Models;

public class WorkerService : BackgroundService
{
    private readonly ServiceBusClient _serviceBusClient;
    private readonly ILogger<WorkerService> _logger;
    private readonly IConfiguration _configuration;
    private ServiceBusProcessor _processor;
    private const int MaxRetryAttempts = 3;

    public WorkerService(ServiceBusClient serviceBusClient, ILogger<WorkerService> logger, IConfiguration configuration)
    {
        _serviceBusClient = serviceBusClient;
        _logger = logger;
        _configuration = configuration;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Worker service starting...");

        try
        {
            var queueName = _configuration.GetValue<string>("ServiceBus:QueueName") ?? "work-queue";
            
            // Create processor options
            var options = new ServiceBusProcessorOptions
            {
                MaxConcurrentCalls = 10,
                AutoCompleteMessages = false,
                ReceiveMode = ServiceBusReceiveMode.PeekLock
            };

            _processor = _serviceBusClient.CreateProcessor(queueName, options);

            // Register message handler
            _processor.ProcessMessageAsync += ProcessMessageHandler;
            
            // Register error handler
            _processor.ProcessErrorAsync += ProcessErrorHandler;

            // Start processing
            await _processor.StartProcessingAsync(stoppingToken);
            _logger.LogInformation($"Worker service started and listening to queue: {queueName}");

            // Keep the service running
            while (!stoppingToken.IsCancellationRequested)
            {
                await Task.Delay(1000, stoppingToken);
            }

            await _processor.StopProcessingAsync(stoppingToken);
        }
        catch (Exception ex)
        {
            _logger.LogError($"Worker service error: {ex.Message}");
            throw;
        }
    }

    private async Task ProcessMessageHandler(ProcessMessageEventArgs args)
    {
        try
        {
            var messageBody = args.Message.Body.ToString();
            _logger.LogInformation($"Processing message: {args.Message.MessageId}");

            // Simulate message processing with retry logic
            var processed = await ProcessMessageWithRetryAsync(messageBody, args.Message);

            if (processed)
            {
                // Complete the message
                await args.CompleteMessageAsync(args.Message);
                _logger.LogInformation($"Message {args.Message.MessageId} processed successfully");
            }
            else
            {
                // Dead-letter the message
                await args.DeadLetterMessageAsync(args.Message, "Max retries exceeded", "Processing failed after maximum retry attempts");
                _logger.LogWarning($"Message {args.Message.MessageId} moved to dead-letter queue");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error processing message: {ex.Message}");
            // Abandon message to allow reprocessing
            await args.AbandonMessageAsync(args.Message);
        }
    }

    private async Task<bool> ProcessMessageWithRetryAsync(string messageBody, ServiceBusReceivedMessage message)
    {
        int deliveryCount = message.DeliveryCount;
        var maxRetries = _configuration.GetValue<int>("ServiceBus:MaxDeliveryCount", MaxRetryAttempts);

        _logger.LogInformation($"Message delivery count: {deliveryCount}, Max retries: {maxRetries}");

        if (deliveryCount > maxRetries)
        {
            _logger.LogWarning($"Message exceeded max delivery count ({deliveryCount} > {maxRetries})");
            return false;
        }

        try
        {
            // Deserialize message
            var workItem = JsonSerializer.Deserialize<WorkItem>(messageBody);
            
            _logger.LogInformation($"Processing work item: {workItem?.WorkId}");

            // Simulate work processing with exponential backoff retry
            var result = await ExecuteWithRetryAsync(async () =>
            {
                return await SimulateWorkProcessing(workItem);
            }, deliveryCount);

            if (result)
            {
                _logger.LogInformation($"Work item {workItem?.WorkId} processed successfully");
                return true;
            }
            else
            {
                _logger.LogWarning($"Work item {workItem?.WorkId} processing failed");
                return false;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error in retry processing: {ex.Message}");
            return false;
        }
    }

    private async Task<bool> ExecuteWithRetryAsync(Func<Task<bool>> action, int currentRetry)
    {
        try
        {
            return await action();
        }
        catch (Exception ex) when (currentRetry < MaxRetryAttempts)
        {
            // Calculate exponential backoff
            var delay = TimeSpan.FromMilliseconds(Math.Pow(2, currentRetry) * 100);
            _logger.LogWarning($"Retry {currentRetry + 1}/{MaxRetryAttempts} after {delay.TotalMilliseconds}ms. Error: {ex.Message}");
            
            await Task.Delay(delay);
            return await ExecuteWithRetryAsync(action, currentRetry + 1);
        }
    }

    private async Task<bool> SimulateWorkProcessing(WorkItem workItem)
    {
        // Simulate processing time
        var delay = Random.Shared.Next(100, 2000);
        await Task.Delay(delay);

        // Simulate occasional failures (for demonstration)
        var shouldFail = Random.Shared.Next(0, 100) < 5; // 5% failure rate
        
        if (shouldFail)
        {
            throw new InvalidOperationException("Simulated processing failure");
        }

        _logger.LogInformation($"Work item processed: {workItem?.Title}");
        return true;
    }

    private Task ProcessErrorHandler(ProcessErrorEventArgs args)
    {
        _logger.LogError($"Service Bus error - Exception: {args.Exception}");
        return Task.CompletedTask;
    }

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Worker service stopping...");
        
        if (_processor != null)
        {
            await _processor.StopProcessingAsync(cancellationToken);
            await _processor.DisposeAsync();
        }

        await base.StopAsync(cancellationToken);
    }
}
