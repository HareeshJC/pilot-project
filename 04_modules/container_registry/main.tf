resource "azurerm_container_registry" "acr" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = try(var.settings.registery_sku, "Standard")
  admin_enabled                 = try(var.settings.registery_admin_enabled, true)
  public_network_access_enabled = try(var.settings.public_network_access_enabled, true)
  tags                          = var.tags
  dynamic "identity" {
    for_each = lookup(var.settings, "identity", {}) == {} ? [] : [1]

    content {
      type         = var.settings.identity.type
      identity_ids = (try(var.settings.identity.type, {}) == "SystemAssigned") ? [] : [var.user_assigned_identity[var.settings.identity.user_managed_id].id]
    }
  }

  lifecycle {
    ignore_changes = []
  }
}

resource "azurerm_role_assignment" "rbac_container_registry" {
  for_each             = { for val in try(var.settings.rbac, []) : "${var.name}-${replace(val.role_name, " ", "-")}-${val.aad_group_name != "" ? val.aad_group_name : val.resource_id}" => val }
  scope                = azurerm_container_registry.acr.id
  role_definition_name = each.value.role_name
  principal_id         = try(var.aad_groups[each.value.aad_group_name].object_id, each.value.resource_id)
}
