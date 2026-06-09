
output "id" {
  description = "IDs of the created container apps."
  value       = azurerm_container_app.container_app.id
}
output "name" {
  description = "name of the created container apps."
  value       = azurerm_container_app.container_app.name
}
output "identity" {
  value = try(azurerm_container_app.container_app.identity[0].principal_id, null)
}
