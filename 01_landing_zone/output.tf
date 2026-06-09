output "resource_group_main" {
  description = "resource_group main block"
  value = { for val in module.resource_groups : val.name => {
    id   = val.id
    name = val.name
  } }
}

output "user_assigned_identity_main" {
  description = "user assigned identity main block"
  value = { for key, val in azurerm_user_assigned_identity.umid : val.name => {
    id   = azurerm_user_assigned_identity.umid[key].id
    name = azurerm_user_assigned_identity.umid[key].name
    }
  }
}

output "log_analytics_workspace_main" {
  description = "Log analytics workspace Main Block"
  value = { for val in module.log_analytics_workspace : val.name => {
    id   = val.id
    name = val.name
  } }
  sensitive = true
}
