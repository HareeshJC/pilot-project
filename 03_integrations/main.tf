#####################################################################
########################--> RESOURCE GROUP <--#######################
#####################################################################

module "resource_groups" {
  source   = "../04_modules/resource_group"
  for_each = { for val in var.resource_groups : val.name => val }
  name     = each.value.name
  location = try(each.value.location, try(var.location, var.global_settings.default_region))
  tags     = merge(try(each.value.tags, {}), local.all_tags)
}

#***************************************************************************************************************
#               Servicebus Queue
#***************************************************************************************************************

module "service_bus_queue" {
  source       = "../04_modules/servicebus_queue"
  for_each     = { for inst in var.servicebus_queues : inst.name => inst }
  depends_on   = [module.resource_groups]
  namespace_id = local.servicebus_namespace[each.value.servicebus_name].id
  queue_name   = each.value.name
  settings     = each.value
}

module "servicebus_queue_sas" {
  source               = "../04_modules/servicebus_queue_sas_key"
  for_each             = { for inst in var.servicebus_queue_sas : inst.name => inst }
  depends_on           = [module.service_bus_queue]
  sharedaccesskey_name = each.value.name
  servicebus_queue_id  = module.service_bus_queue[each.value.queue_name].id
  listen               = try(each.value.listen, false)
  send                 = try(each.value.send, false)
  manage               = try(each.value.manage, false)
}

resource "azurerm_key_vault_secret" "sb_queue_secret" {
  for_each     = { for val in var.servicebus_queue_sas : val.name => val if try(val.secret_management, null) != null }
  name         = format("%s-connection-string", module.servicebus_queue_sas[each.key].name)
  value        = module.servicebus_queue_sas[each.key].primary_connection_string
  key_vault_id = local.combined_keyvaults[each.value.secret_management.keyvault_name].id
}

#####################################################################
########################--> CONTAINER APPS <--#######################
#####################################################################

module "container_apps" {
  source   = "../04_modules/container_app"
  for_each = { for inst in var.container_apps : inst.name => inst }
  depends_on = [
    module.resource_groups
  ]

  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  container_app_environment_id = try(local.container_app_environment_main[each.value.container_app_environment_name].id, each.value.container_app_environment_id)
  revision_mode                = try(each.value.revision_mode, "Single")
  workload_profile_name        = try(each.value.workload_profile_name, "Consumption")
  settings                     = each.value
  tags                         = merge(local.all_tags, try(each.value.tags, {}))
  user_assigned_identity       = local.user_assigned_identity
}
resource "azurerm_role_assignment" "container_app_rbac_acr" {
  for_each             = { for inst in var.container_apps : inst.name => inst }
  scope                = local.container_registry[each.value.registry.username].id
  role_definition_name = "AcrPull"
  principal_id         = module.container_apps[each.value.name].identity
}
resource "azuread_group_member" "container_apps_group_member" {
  for_each         = { for inst in var.container_apps : inst.name => inst if try(inst.containerapp_access_role, null) != null }
  group_object_id  = local.combined_azuread_group[each.value.containerapp_access_role].object_id
  member_object_id = module.container_apps[each.key].identity
}

// ============================
// Azure System Alerts
// ============================
module "alerts" {
  source     = "../04_modules/metric_alert_rule"
  for_each   = { for alert in var.alerts : alert.metric_alert_name => alert }
  depends_on = [module.alert_action_group]

  metric_alert_name   = each.value.metric_alert_name
  resource_group_name = try(each.value.resource_group_name)
  location            = try(each.value.location, var.location)
  scopes = flatten([
    for resource_name in each.value.resource_names :
    each.value.resource_type == "servicebus_namespaces" ? local.servicebus_namespace[resource_name].id : null
  ])
  action_group_id = try(each.value.action_group_id, try(module.alert_action_group[each.value.action_group_name].id, null))
  settings        = merge(var.alert_common, each.value)
  tags            = merge(try(each.value.custom_properties, {}), each.value.tags)
}

#***************************************************************************************************************
#               Alert Action Groups
#***************************************************************************************************************
module "alert_action_group" {
  source     = "../04_modules/alert_action_group"
  for_each   = { for inst in var.alert_action_groups : inst.name => inst }
  depends_on = [module.resource_groups]

  name                = each.value.name
  short_name          = each.value.short_name
  resource_group_name = each.value.resource_group_name
  # automation_runbook_receiver = each.value
}
