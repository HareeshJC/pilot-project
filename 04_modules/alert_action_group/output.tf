output "id" {
  value       = azurerm_monitor_action_group.alert_action_group.id
  description = "id - The ID of the Alert Action Group."
}

output "name" {
  value       = azurerm_monitor_action_group.alert_action_group.name
  description = "Alert Action Group name."
}