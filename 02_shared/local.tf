locals {
  tenant_id                  = var.tenant_id
  all_tags                   = var.shared_tags
  landing_zone               = data.terraform_remote_state.sub.outputs
  user_assigned_identity     = try(local.landing_zone.user_assigned_identity_main, {})
  log_analytics_workspace_id = try(local.landing_zone.log_analytics_workspace_main, {})

  result_vnet_main = { for key, val in module.vnet : key => {
    id   = val.id
    name = val.name
  } }

  result_subnet_main = { for key, val in module.vnet_subnet : key => {
    id   = val.id
    name = val.name
  } }

  virtual_network_links = [{
    virtual_network_id   = data.azurerm_virtual_network.hub_vnet.id
    registration_enabled = false
  }]

  aad_group = { for val in azuread_group.group : val.display_name => {
    name      = val.display_name
    object_id = val.object_id
    }
  }

  dns_zons = { for val in module.private_dns_zone : val.private_dns_zone_name => {
    name = val.private_dns_zone_name
    id   = val.private_dns_zone_id
    }
  }

  result_app_insights = { for val in module.app_insights : val.name => {
    id                  = val.id
    name                = val.name
    instrumentation_key = val.instrumentation_key
    connection_string   = val.connection_string
  } }

  result_key_vaults = { for val in module.keyvaults : val.name => {
    id   = val.id
    name = val.name
  } }

  result_private_endpoints = { for val in module.keyvault_private_endpoints : val.name => {
    id                       = val.id
    name                     = val.name
    private_dns_zone_group   = val.private_dns_zone_group
    private_dns_zone_configs = val.private_dns_zone_configs
  } }
}
