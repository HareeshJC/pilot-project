location                                            = "southindia"
subscription_id                                     = "__#subscription_id#__"
remote_state_backend_storage_account_name           = "__#remote_state_backend_storage_account_name#__"
remote_state_backend_storage_account_contianer_name = "statestorage"
remote_state_backend_state_file_name                = "lz-__#component_instance#__.tfstate"
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
  "ProvisionedType"     = "LandingZone"
}

global_settings = {
  default_region = "southindia"
  regions = {
    region1 = "southindia"
    region2 = "centralindia"
  }
  environment_name = "DV"
}

resource_groups = [
  {
    name     = "rg-__#environment_abbr#__-__#service_id#__-landingzone-__#location_abbreviation#__-__#environment_instance#__"
    location = "southindia"
  }
]

managed_identities = {
  lz-dv01 = {
    name                = "lz-__#environment_abbr#__-__#service_id#__-umid-__#environment_instance#__"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-landingzone-__#location_abbreviation#__-__#environment_instance#__"
  }
}

log_analytics_workspace = [
  {
    name                = "law-__#environment_abbr#__-__#service_id#__-landingzone-__#environment_instance#__"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-landingzone-__#location_abbreviation#__-__#environment_instance#__"
  }
]
