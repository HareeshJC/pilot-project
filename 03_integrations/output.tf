output "resource_group_main" {
  description = "resource_group main block"
  value = { for val in module.resource_groups : val.name => {
    id   = val.id
    name = val.name
  } }
}

output "container_app_main" {
  description = "container apps main block"
  value       = local.result_container_apps
}