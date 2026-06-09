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
#   Managed Identity
#***************************************************************************************************************

resource "azurerm_user_assigned_identity" "umid" {
  for_each = var.managed_identities

  location            = try(each.value.location, var.location)
  resource_group_name = each.value.resource_group_name
  name                = each.value.name

  depends_on = [
    module.resource_groups
  ]
}

#***************************************************************************************************************
#   Log Analytics
#***************************************************************************************************************
module "log_analytics_workspace" {

  source     = "../04_modules/log_analytics_workspace"
  for_each   = { for val in var.log_analytics_workspace : val.name => val }
  depends_on = [module.resource_groups]

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = try(each.value.location, var.location)
  settings            = each.value
  tags                = merge(try(each.value.tags, {}), local.all_tags)
}

