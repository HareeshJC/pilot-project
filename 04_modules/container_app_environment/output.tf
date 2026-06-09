output "id" {
  description = "The ID of the Container App Environment"
  sensitive   = false
  value       = try(azurerm_container_app_environment.container_env.id)
}

output "name" {
  description = "The ID of the Container App Environment"
  sensitive   = false
  value       = try(azurerm_container_app_environment.container_env.name)
}
