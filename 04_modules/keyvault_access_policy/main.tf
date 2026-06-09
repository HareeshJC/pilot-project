resource "azurerm_key_vault_access_policy" "access_policy" {
  key_vault_id            = var.key_vault_id
  tenant_id               = var.tenant_id
  object_id               = can(regex(local.uuid_regex, var.settings.object_id)) ? var.settings.object_id : try(var.aad_groups[var.settings.object_id].object_id, null)
  key_permissions         = try(var.settings.key_permissions, null)
  secret_permissions      = try(var.settings.secret_permissions, null)
  storage_permissions     = try(var.settings.storage_permissions, null)
  certificate_permissions = try(var.settings.certificate_permissions, null)

  lifecycle {
    ignore_changes = []
  }
}

locals {
  uuid_regex = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
}
