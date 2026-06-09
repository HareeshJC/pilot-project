# module to create metric alert for any resource
resource "azurerm_monitor_metric_alert" "metric_alert" {
  name                     = var.metric_alert_name
  resource_group_name      = var.resource_group_name
  target_resource_location = var.location
  target_resource_type     = var.settings.metric_namespace
  scopes                   = var.scopes

  criteria {
    metric_namespace = var.settings.metric_namespace
    metric_name      = var.settings.metric_name
    aggregation      = var.settings.aggregation
    operator         = var.settings.operator
    threshold        = var.settings.threshold
    dynamic "dimension" {
      for_each = try(var.settings.dimension_name, "") != "" ? [var.settings.dimension_name] : []
      content {
        name     = dimension.value
        operator = var.settings.dimension_operator
        values   = var.settings.dimension_values
      }
    }
  }
  description   = var.settings.description
  severity      = var.settings.severity
  enabled       = var.settings.enabled
  window_size   = var.settings.window_size
  frequency     = var.settings.frequency
  auto_mitigate = var.settings.auto_mitigate
  tags          = var.tags
  action {
    action_group_id    = try(var.action_group_id, null)
    webhook_properties = try(var.settings.custom_properties, {})
  }
}
