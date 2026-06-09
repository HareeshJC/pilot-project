output "id" {
  value       = azurerm_application_insights.main.id
  description = "id - The ID of the Service Plan."
}

output "name" {
  value       = azurerm_application_insights.main.name
  description = "resource name"
}

output "instrumentation_key" {
  value     = azurerm_application_insights.main.instrumentation_key
  sensitive = true
}

output "connection_string" {
  value     = azurerm_application_insights.main.connection_string
  sensitive = true
}
