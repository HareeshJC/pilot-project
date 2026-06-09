output "id" {
  value       = azurerm_container_registry.acr.id
  description = "id - The ID of the Container Registry."
}

output "name" {
  value       = azurerm_container_registry.acr.name
  description = "Automation Account name."
}

output "login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The URL that can be used to log into the container registry."
}

output "admin_username" {
  value       = azurerm_container_registry.acr.admin_username
  description = "The Username associated with the Container Registry Admin account"
}

output "admin_password" {
  value       = azurerm_container_registry.acr.admin_password
  description = "The primary key of the user"
  sensitive   = true
}
