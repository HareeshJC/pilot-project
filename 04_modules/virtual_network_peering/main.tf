resource "azurerm_virtual_network_peering" "source_to_target" {
  name                      = format("%s%s%s", var.source_virtual_network_name, var.seperator, var.target_virtual_network_name)
  virtual_network_name      = var.source_virtual_network_name
  resource_group_name       = var.source_virtual_network_resource_group_name
  remote_virtual_network_id = var.target_virtual_network_id

  allow_forwarded_traffic = try(var.settings.peering_outgoing.allow_forwarded_traffic, false)
  allow_gateway_transit   = try(var.settings.peering_outgoing.allow_gateway_transit, false)
  use_remote_gateways     = try(var.settings.peering_outgoing.use_remote_gateways, false)

  lifecycle {
    ignore_changes = [
      remote_virtual_network_id,
      resource_group_name,
      virtual_network_name
    ]
  }
}

resource "azurerm_virtual_network_peering" "target_to_source" {
  count                     = var.bidirectional == true ? 1 : 0
  name                      = format("%s%s%s", var.target_virtual_network_name, var.seperator, var.source_virtual_network_name)
  virtual_network_name      = var.target_virtual_network_name
  resource_group_name       = var.target_virtual_network_resource_group_name
  remote_virtual_network_id = var.source_virtual_network_id

  allow_forwarded_traffic = try(var.settings.peering_incoming.allow_forwarded_traffic, false)
  allow_gateway_transit   = try(var.settings.peering_incoming.allow_gateway_transit, false)
  use_remote_gateways     = try(var.settings.peering_incoming.use_remote_gateways, false)

  lifecycle {
    ignore_changes = [
      remote_virtual_network_id,
      resource_group_name,
      virtual_network_name
    ]
  }
}