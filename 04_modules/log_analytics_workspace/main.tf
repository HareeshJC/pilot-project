resource "azurerm_log_analytics_workspace" "loganalyticsworkspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = try(var.settings.retention_in_days, "90")
  tags                = var.tags
}