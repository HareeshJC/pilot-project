# data "azurerm_private_dns_zone" "kv_id_dnszone" {
#   name                = "privatelink.vaultcore.azure.net"
#   resource_group_name = var.private_dns_rg_name
# }

# data "azurerm_private_dns_zone" "servicebus_id_dnszone" {
#   name                = "privatelink.servicebus.windows.net"
#   resource_group_name = var.private_dns_rg_name
# }

# data "azurerm_private_dns_zone" "acr_id_dnszone" {
#   name                = "privatelink.azurecr.io"
#   resource_group_name = var.private_dns_rg_name
# }

data "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_virtual_network_name
  resource_group_name = var.hub_virtual_network_rg_name
}

data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = var.hub_virtual_network_subnet_name
  virtual_network_name = var.hub_virtual_network_name
  resource_group_name  = var.hub_virtual_network_rg_name
}