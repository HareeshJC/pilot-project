resource "azurerm_private_endpoint" "pepoint" {
  name                = format("%s-pep", var.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = format("%s-psc", var.name)
    private_connection_resource_id = var.resource_id
    is_manual_connection           = try(var.settings.is_manual_connection, false)
    subresource_names              = try(var.settings.subresource_names, [])
    request_message                = try(var.settings.request_message, null)
  }
  private_dns_zone_group {
    name                 = "pdnszg-${var.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  lifecycle {
    ignore_changes = []
  }
}