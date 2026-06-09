resource "azurerm_monitor_action_group" "alert_action_group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name

  # dynamic "automation_runbook_receiver" {
  #   for_each = var.automation_runbook_receiver != {} ? [var.automation_runbook_receiver] : []

  #   content {
  #     name                    = var.automation_runbook_receiver.automation_account_name
  #     automation_account_id   = var.automation_runbook_receiver.automation_account_id
  #     runbook_name            = var.automation_runbook_receiver.runbook_name
  #     webhook_resource_id     = var.automation_runbook_receiver.webhook_resource_id
  #     is_global_runbook       = try(var.automation_runbook_receiver.is_global_runbook, true)
  #     service_uri             = var.automation_runbook_receiver.service_uri
  #     use_common_alert_schema = try(var.automation_runbook_receiver.use_common_alert_schema, true)
  #   }
  # }
}