output "id" {
  value       = azurerm_servicebus_subscription.main.id
  description = "The ServiceBus topic subscription ID."
}


output "name" {
  value       = azurerm_servicebus_subscription.main.name
  description = "The ServiceBus topic subscription name"
}