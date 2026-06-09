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

#################**********************************************************************************************************************
######                                                  Network Block
#################**********************************************************************************************************************


module "vnet" {
  source               = "../04_modules/virtual_network"
  for_each             = var.virtual_networks
  depends_on           = [module.resource_groups]
  virtual_network_name = each.value.name
  location             = try(each.value.location, var.location)
  resource_group_name  = each.value.resource_group_name
  address_space        = each.value.address_space
  tags                 = merge(try(each.value.tags, {}), local.all_tags)
  dns_servers          = try(each.value.dns_servers, null)
  # ddos_protection_plan_id = each.value.enable_ddos_protection_plan == true ? data.azurerm_network_ddos_protection_plan.connectivity_ddos_protection_plan.id : null
}

module "vnet_subnet" {
  source               = "../04_modules/virtual_network_subnet"
  for_each             = var.subnets
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
  address_prefixes     = each.value.address_prefixes
  settings             = each.value
  depends_on = [
    module.vnet
  ]
}

module "virtual_network_peering" {
  source     = "../04_modules/virtual_network_peering"
  depends_on = [module.vnet]

  for_each                                   = var.virtual_network_peerings
  source_virtual_network_name                = each.value.source_virtual_network_name
  source_virtual_network_id                  = local.result_vnet_main[each.value.source_virtual_network_key].id
  source_virtual_network_resource_group_name = each.value.source_virtual_network_resource_group_name
  settings                                   = each.value
  bidirectional                              = try(each.value.bidirectional, false)
  target_virtual_network_name                = var.hub_virtual_network_name
  target_virtual_network_id                  = data.azurerm_virtual_network.hub_vnet.id
  target_virtual_network_resource_group_name = var.hub_virtual_network_rg_name
  seperator                                  = try(each.value.seperator, "-")
}

####################################################################
######################--> PRIVATE DNS ZONE <--######################
####################################################################
module "private_dns_zone" {
  source                = "../04_modules/private_dns_zone"
  for_each              = { for id in var.private_dns_zones : id.id => id }
  private_dns_zone_name = each.value.dns_zone_name
  resource_group_name   = each.value.resource_group_name
  soa_records           = each.value.soa_records
  records               = each.value.records
  cname_records         = each.value.cname_records
  txt_records           = each.value.txt_records
  virtual_network_links = try(each.value.virtual_network_links, local.virtual_network_links)
  tags                  = merge(local.all_tags, try(each.value.tags, {}))
  depends_on = [
    module.resource_groups
  ]
}

#################**********************************************************************************************************************
######                                                  Azure ad group and apps
#################**********************************************************************************************************************

resource "azuread_group" "group" {
  //for_each                = toset(var.aad_groups)
  for_each         = { for inst in var.aad_groups : inst => inst }
  display_name     = format("azgrp-%s", each.value)
  security_enabled = true
}

#################**********************************************************************************************************************
######                                                  Keyvault block
#################**********************************************************************************************************************
module "keyvaults" {
  source   = "../04_modules/keyvault"
  for_each = { for val in var.keyvaults : val.name => val }

  location            = try(each.value.location, var.location)
  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  settings            = each.value
  tenant_id           = try(each.value.tenant_id, local.tenant_id)
  tags                = merge(local.all_tags, try(each.value.tags, {}))
  depends_on = [
    module.resource_groups
  ]
}

module "keyvault_private_endpoints" {
  source   = "../04_modules/private_endpoint"
  for_each = { for val in var.keyvault_private_endpoints : val.name => val }
  depends_on = [
    module.keyvaults,
    module.private_dns_zone
  ]

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  location             = try(each.value.location, var.location)
  settings             = each.value
  resource_id          = module.keyvaults[each.value.keyvault_name].id
  subnet_id            = try(local.result_subnet_main[each.value.subnet_id].id, data.azurerm_subnet.private_endpoint_subnet.id)
  private_dns_zone_ids = [local.dns_zons[each.value.private_dns_zone_name].id]
  tags                 = merge(local.all_tags, try(each.value.tags, {}))
}

resource "time_sleep" "wait_for_keyvault_private_endpoint" {
  depends_on = [
    module.keyvault_private_endpoints
  ]

  create_duration = "60s"
}

module "keyvault_access_policy" {
  source   = "../04_modules/keyvault_access_policy"
  for_each = { for val in var.keyvault_access_policies : val.name => val }

  key_vault_id = module.keyvaults[each.value.keyvault_name].id
  settings     = each.value
  tenant_id    = try(each.value.tenant_id, local.tenant_id)
  aad_groups   = local.aad_group
  depends_on   = []
}

resource "azurerm_key_vault_secret" "predetermined_secret_key" {
  for_each     = { for inst in var.keyvault_manual_secrets : inst.name => inst }
  depends_on   = [module.keyvault_access_policy, time_sleep.wait_for_keyvault_private_endpoint]
  name         = each.value.name
  value        = try(each.value.value, "dummy")
  key_vault_id = module.keyvaults[each.value.keyvault_name].id
  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
}

#***************************************************************************************************************
#               Application insights
#***************************************************************************************************************
module "app_insights" {
  source     = "../04_modules/app_insights"
  depends_on = [module.resource_groups]

  for_each             = { for inst in var.app_insights : inst.name => inst }
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  location             = try(each.value.location, var.location)
  workspace_id         = try(local.log_analytics_workspace_id[each.value.log_analytics_workspace_name].id, null)
  tags                 = merge(local.all_tags, try(each.value.tags, {}))
  daily_data_cap_in_gb = try(each.value.daily_data_cap_in_gb, 100)
}

resource "azurerm_key_vault_secret" "app_insights_secret" {
  depends_on   = [module.app_insights, module.keyvault_access_policy, time_sleep.wait_for_keyvault_private_endpoint]
  for_each     = { for val in var.app_insights : val.name => val if try(val.secret_management, null) != null }
  name         = format("%s-instrumentation-key", module.app_insights[each.key].name)
  value        = module.app_insights[each.key].instrumentation_key
  key_vault_id = module.keyvaults[each.value.secret_management.keyvault_name].id
}

#***************************************************************************************************************
#               Container Registry
#***************************************************************************************************************

module "container_registry" {
  source     = "../04_modules/container_registry"
  for_each   = var.container_registeries
  depends_on = [module.resource_groups]

  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  location               = try(each.value.location, var.location)
  settings               = each.value
  tags                   = merge(local.all_tags, try(each.value.tags, {}))
  user_assigned_identity = local.user_assigned_identity
}

resource "azurerm_key_vault_secret" "container_registry_secret" {
  depends_on   = [module.container_registry, module.keyvault_access_policy, time_sleep.wait_for_keyvault_private_endpoint]
  for_each     = var.container_registeries
  name         = format("%s-password", each.value.name)
  value        = module.container_registry[each.key].admin_password
  key_vault_id = module.keyvaults[each.value.secret_management.keyvault_name].id
}

#***************************************************************************************************************
#               Servicebus namespace
#***************************************************************************************************************

module "servicebus_namespaces" {
  source   = "../04_modules/servicebus_namespace"
  for_each = { for val in var.servicebus_namespaces : val.name => val }

  depends_on = [module.resource_groups, azuread_group.group]

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = try(each.value.location, var.location)
  tags                = merge(local.all_tags, try(each.value.tags, {}))
  aad_groups          = local.aad_group
  settings            = each.value
}

resource "azurerm_key_vault_secret" "sb_secret" {
  depends_on   = [module.servicebus_namespaces, module.keyvault_access_policy, time_sleep.wait_for_keyvault_private_endpoint]
  for_each     = { for val in var.servicebus_namespaces : val.name => val if try(val.secret_management, null) != null }
  name         = format("%s-connection-string", module.servicebus_namespaces[each.key].name)
  value        = module.servicebus_namespaces[each.key].primary_connection_string
  key_vault_id = module.keyvaults[each.value.secret_management.keyvault_name].id
}



#***************************************************************************************************************
#               Container app environment
#***************************************************************************************************************
module "container_app_environment" {
  source     = "../04_modules/container_app_environment"
  for_each   = { for val in var.container_environments : val.name => val }
  depends_on = [module.vnet_subnet]

  name                           = each.value.name
  resource_group_name            = each.value.resource_group_name
  location                       = try(each.value.location, var.location)
  infrastructure_subnet_id       = try(local.result_subnet_main[each.value.subnet_id].id, each.value.subnet_id)
  internal_load_balancer_enabled = try(each.value.internal_load_balancer_enabled, false)
  log_analytics_workspace_id     = try(local.log_analytics_workspace_id[each.value.log_analytics_workspace_name].id, null)
  tags                           = merge(local.all_tags, try(each.value.tags, {}))
  # workload_profile_name          = try(each.value.workload_profile_name, "env_workload_profile")
  # workload_profile_type          = try(each.value.workload_profile_type, null)
}
