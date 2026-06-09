resource "azurerm_application_insights" "main" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  application_type     = var.application_type
  workspace_id         = var.workspace_id
  tags                 = var.tags
  daily_data_cap_in_gb = var.daily_data_cap_in_gb
}