output "id" {
  value       = azurerm_monitor_metric_alert.metric_alert.id
  description = "resource id."
  depends_on  = []
}


output "name" {
  value       = azurerm_monitor_metric_alert.metric_alert.name
  description = "resource name"
  depends_on  = []
}