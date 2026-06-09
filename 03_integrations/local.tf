locals {
  tenant_id                      = var.tenant_id
  all_tags                       = var.shared_tags
  landing_zone                   = data.terraform_remote_state.lz.outputs
  shared                         = data.terraform_remote_state.shared.outputs
  user_assigned_identity         = try(local.landing_zone.user_assigned_identity_main, {})
  combined_azuread_group         = merge(try(local.shared.aad_group_main, {}), {})
  servicebus_namespace           = try(local.shared.servicebus_namespaces_main, {})
  container_app_environment_main = try(local.shared.container_app_environment_main, {})
  container_registry             = try(local.shared.container_registry_main, {})
  combined_keyvaults             = merge(try(local.shared.keyvault_main, {}), {})

  result_container_apps = { for val in module.container_apps : val.name => {
    id      = val.id
    name    = val.name
    rbac_id = val.identity
    }
  }

}
