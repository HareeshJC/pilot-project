output "id" {
  value       = azurerm_servicebus_queue_authorization_rule.main.id
  description = "The ServiceBus topic SAS key ID."
}

output "name" {
  value       = azurerm_servicebus_queue_authorization_rule.main.name
  description = "The ServiceBus topic SAS key name."
}

output "primary_connection_string" {
  value       = azurerm_servicebus_queue_authorization_rule.main.primary_connection_string
  description = "The Primary Connection String(s) for the Service Bus Topic authorization Rules"
  sensitive   = true
}

output "secondary_connection_string" {
  value       = azurerm_servicebus_queue_authorization_rule.main.secondary_connection_string
  description = "The Secondary Connection String(s) for the Service Bus Topic authorization Rules"
  sensitive   = true
}