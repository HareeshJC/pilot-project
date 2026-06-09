resource "azurerm_container_app_environment" "container_env" {
  name                           = var.name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  tags                           = var.tags

  # workload_profile {
  #   name                  = try(var.workload_profile_name, "env_workload_profile")
  #   workload_profile_type = try(var.workload_profile_type, "Consumption") # Set to Consumption profile
  # }

  lifecycle {
    precondition {
      condition     = var.internal_load_balancer_enabled == null || var.infrastructure_subnet_id != null
      error_message = "`container app environment internal_load_balancer_enabled` can only be set when `container app environment infrastructure_subnet_id` is specified."
    }
    ignore_changes = [workload_profile]
  }
}