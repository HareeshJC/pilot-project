location                                            = "southindia"
tenant_id                                           = "__#tenant_id#__"
subscription_id                                     = "__#subscription_id#__"
remote_state_backend_storage_account_name           = "__#remote_state_backend_storage_account_name#__"
remote_state_backend_storage_account_contianer_name = "statestorage"
landing_zone_remote_state_backend_state_file_name   = "lz-__#component_instance#__.tfstate"
shared_remote_state_backend_state_file_name         = "shared-__#component_instance#__.tfstate"
remote_state_backend_resource_group_name            = "__#remote_state_backend_resource_group_name#__"
remote_state_backend_subscription_id                = "__#remote_state_subscription_id#__"

shared_tags = {
  "Application"         = "iPaaS"
  "Environment"         = "DV"
  "EnvironmentInstance" = "__#environment_instance#__"
  "Operations team"     = "Cloud operations"
  "Region"              = "South India"
  "Service class"       = "DV"
  "Data classification" = "Confidential"
  "ProvisionedType"     = "IntegrationZone"
}

global_settings = {
  default_region = "southindia"
  regions = {
    region1 = "southindia"
    region2 = "centralindia"
  }
  environment_name = "dv"
}