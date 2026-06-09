output "id" {
  value       = azurerm_servicebus_topic.main.id
  description = "The ServiceBus topic ID."
}


output "name" {
  value       = azurerm_servicebus_topic.main.name
  description = "The ServiceBus topic name"
}