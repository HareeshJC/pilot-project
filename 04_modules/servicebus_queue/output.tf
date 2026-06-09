output "id" {
  value       = azurerm_servicebus_queue.main.id
  description = "The ServiceBus queue ID."
}


output "name" {
  value       = azurerm_servicebus_queue.main.name
  description = "The ServiceBus queue name"
}