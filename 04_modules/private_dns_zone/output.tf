output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.private_dns_zone.id
  description = "The ID of the Private DNS Zone."
}

output "private_dns_zone_name" {
  value       = azurerm_private_dns_zone.private_dns_zone.name
  description = "The name of the Private DNS Zone."
}

output "fqdn" {
  value       = azurerm_private_dns_zone.private_dns_zone.soa_record[*].fqdn
  description = "The FQDN of the Private DNS Zone."
}

output "number_of_record_sets" {
  value       = azurerm_private_dns_zone.private_dns_zone.number_of_record_sets
  description = "The number of record sets in this Private DNS Zone."
}