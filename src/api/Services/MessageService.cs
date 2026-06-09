using Azure.Messaging.ServiceBus;
using System.Text.Json;
using IntegrationAPI.Controllers;

public class MessageService
{
    private readonly ServiceBusClient _serviceBusClient;
    private readonly ILogger<MessageService> _logger;
    private readonly IConfiguration _configuration;
    private ServiceBusSender _sender;

    public MessageService(ServiceBusClient serviceBusClient, ILogger<MessageService> logger, IConfiguration configuration)
    {
        _serviceBusClient = serviceBusClient;
        _logger = logger;
        _configuration = configuration;
    }

    public async Task SendMessageAsync(WorkItem workItem)
    {
        try
        {
            var queueName = _configuration.GetValue<string>("ServiceBus:QueueName") ?? "work-queue";
            _sender = _serviceBusClient.CreateSender(queueName);

            var messageBody = JsonSerializer.Serialize(workItem);
            var message = new ServiceBusMessage(messageBody)
            {
                ContentType = "application/json",
                MessageId = workItem.WorkId,
                Subject = "WorkItem",
                TimeToLive = TimeSpan.FromMinutes(5)
            };

            // Add correlation ID for tracing
            message.ApplicationProperties["CorrelationId"] = workItem.WorkId;
            message.ApplicationProperties["Timestamp"] = DateTime.UtcNow;

            await _sender.SendMessageAsync(message);
            
            _logger.LogInformation($"Message sent to Service Bus: {workItem.WorkId}");
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error sending message to Service Bus: {ex.Message}");
            throw;
        }
        finally
        {
            if (_sender != null)
            {
                await _sender.DisposeAsync();
            }
        }
    }

    public async Task<ServiceBusReceivedMessage?> ReceiveMessageAsync(string queueName)
    {
        try
        {
            var receiver = _serviceBusClient.CreateReceiver(queueName);
            var message = await receiver.ReceiveMessageAsync(TimeSpan.FromSeconds(10));
            
            if (message != null)
            {
                _logger.LogInformation($"Message received from queue: {message.MessageId}");
            }

            await receiver.DisposeAsync();
            return message;
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error receiving message from Service Bus: {ex.Message}");
            throw;
        }
    }
}
