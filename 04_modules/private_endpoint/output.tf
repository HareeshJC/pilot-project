output "id" {
  value       = azurerm_private_endpoint.pepoint.id
  description = "The ID of the private endpoint."
}
output "name" {
  value       = azurerm_private_endpoint.pepoint.name
  description = "The name of the private endpoint."
}
output "private_dns_zone_group" {
  value       = azurerm_private_endpoint.pepoint.private_dns_zone_group
  description = "The private DNS zone group associated with the private endpoint."
}
output "private_dns_zone_configs" {
  value       = azurerm_private_endpoint.pepoint.private_dns_zone_configs
  description = "The private DNS zone configurations associated with the private endpoint."
}