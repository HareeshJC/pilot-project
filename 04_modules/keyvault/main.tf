resource "azurerm_key_vault" "keyvault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = try(var.settings.sku_name, "standard")
  tags                = var.tags

  enabled_for_deployment          = try(var.settings.enabled_for_deployment, false)
  enabled_for_disk_encryption     = try(var.settings.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = try(var.settings.enabled_for_template_deployment, false)
  purge_protection_enabled        = try(var.settings.purge_protection_enabled, true)
  soft_delete_retention_days      = try(var.settings.soft_delete_retention_days, 7)
  public_network_access_enabled   = try(var.settings.public_network_access_enabled, true)
  timeouts {
    delete = "60m"

  }

  lifecycle {
    ignore_changes = []
  }
}