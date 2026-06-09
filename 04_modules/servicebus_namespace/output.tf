output "id" {
  value       = azurerm_servicebus_namespace.sb.id
  description = "The ServiceBus Namespace ID."
}

output "name" {
  value       = azurerm_servicebus_namespace.sb.name
  description = "The ServiceBus Namespace name"
}

output "primary_connection_string" {
  value       = azurerm_servicebus_namespace.sb.default_primary_connection_string
  description = "The primary connection string for the authorization rule RootManageSharedAccessKey"
  sensitive   = true
}

output "rbac_id" {
  value       = try(azurerm_servicebus_namespace.sb.identity[0].principal_id, null)
  description = "The Principal ID for the Service Principal associated with the Managed Service Identity of this ServiceBus Namespace"
}
