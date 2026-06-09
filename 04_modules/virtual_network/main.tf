resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags

  dns_servers = var.dns_servers

  #   dynamic "ddos_protection_plan" {
  #     for_each = try(var.ddos_protection_plan_id, null) != null ? [1] : []

  #     content {
  #       id     = var.ddos_protection_plan_id
  #       enable = true
  #     }
  #   }

}