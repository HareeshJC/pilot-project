output "resource_group_main" {
  description = "resource_group main block"
  value = { for val in module.resource_groups : val.name => {
    id   = val.id
    name = val.name
  } }
}

output "vnet_main" {
  description = "virtual network main block"
  value       = local.result_vnet_main
}

output "subnet_main" {
  description = "subnet main block"
  value       = local.result_subnet_main
  sensitive   = true
}

output "private_endpoints_main" {
  description = "private endpoints main block"
  value       = local.result_private_endpoints
  sensitive   = true
}

output "aad_group_main" {
  //for_each                = toset(var.aad_groups)
  description = "Azure ad group output"
  value       = local.aad_group
}

output "dns_zons" {
  value       = { for key, val in local.dns_zons : key => { id = val.id } }
  description = "DNS zone with key value"
  depends_on  = []
}

output "app_insights_main" {
  description = "app_insights main block"
  value       = local.result_app_insights
  sensitive   = true
}

output "container_registry_main" {
  description = "Container Registry Main Block"
  value = { for val in module.container_registry : val.name => {
    id             = val.id
    name           = val.name
    admin_username = val.admin_username
    admin_password = val.admin_password
    login_server   = val.login_server
  } }
  sensitive = true
}

output "keyvault_main" {
  description = "Keyvault main block"
  value       = local.result_key_vaults
  sensitive   = true
}

output "servicebus_namespaces_main" {
  description = "servicebus_namespaces main block"
  value = { for val in module.servicebus_namespaces : val.name => {
    id                        = val.id
    name                      = val.name
    rbac_id                   = val.rbac_id
    primary_connection_string = val.primary_connection_string
  } }
  sensitive = true
}

output "container_app_environment_main" {
  description = "The ID of the Container App Environment"
  value = { for val in module.container_app_environment : val.name => {
    id   = val.id
    name = val.name
  } }
}
