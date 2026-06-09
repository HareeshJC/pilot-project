resource "azurerm_subnet" "subnet" {

  name                                          = var.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = var.address_prefixes
  service_endpoints                             = try(var.settings.service_endpoints, null)
  private_endpoint_network_policies             = try(var.settings.enforce_private_link_endpoint_network_policies, "Enabled")
  private_link_service_network_policies_enabled = try(var.settings.enforce_private_link_service_network_policies, true)


  dynamic "delegation" {
    for_each = var.settings.subnet_delegation
    content {
      name = delegation.value.name

      service_delegation {
        name    = try(delegation.value.service_name, "ERROR")
        actions = try(delegation.value.actions, null)
      }
    }
  }
}