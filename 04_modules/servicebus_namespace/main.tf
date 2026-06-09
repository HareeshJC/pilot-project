resource "azurerm_servicebus_namespace" "sb" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku                          = try(var.settings.sku, "Standard")
  premium_messaging_partitions = try(var.settings.sku, "Premium") == "Premium" ? try(var.settings.premium_messaging_partitions, 1) : 0
  identity {
    type = "SystemAssigned"
  }

  capacity = try(var.settings.sku, "Premium") == "Premium" ? try(var.settings.capacity, 1) : 0

  local_auth_enabled            = try(var.settings.local_auth_enabled, true)
  public_network_access_enabled = try(var.settings.public_network_access_enabled, true)
  minimum_tls_version           = try(var.settings.minimum_tls_version, "1.2")
  tags                          = var.tags
}

resource "azurerm_role_assignment" "rbac_servicebus" {
  for_each             = { for val in try(var.settings.rbac, []) : "${var.name}-${replace(val.role_name, " ", "-")}-${val.aad_group_name != "" ? val.aad_group_name : val.resource_id}" => val }
  scope                = azurerm_servicebus_namespace.sb.id
  role_definition_name = each.value.role_name
  principal_id         = try(var.aad_groups[each.value.aad_group_name].object_id, each.value.resource_id)
}