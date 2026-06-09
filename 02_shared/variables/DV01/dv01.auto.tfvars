location                                            = "southindia"
tenant_id                                           = "__#tenant_id#__"
subscription_id                                     = "__#subscription_id#__"
remote_state_backend_storage_account_name           = "__#remote_state_backend_storage_account_name#__"
remote_state_backend_storage_account_contianer_name = "statestorage"
remote_state_backend_state_file_name                = "lz-__#component_instance#__.tfstate"
remote_state_backend_resource_group_name            = "__#remote_state_backend_resource_group_name#__"
remote_state_backend_subscription_id                = "__#remote_state_subscription_id#__"
private_dns_rg_name                                 = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
hub_virtual_network_name                            = "github-vnet78"
hub_virtual_network_rg_name                         = "__#remote_state_backend_resource_group_name#__"
hub_virtual_network_subnet_name                     = "default"

shared_tags = {
  "Application"         = "iPaaS"
  "Environment"         = "DV"
  "EnvironmentInstance" = "__#environment_instance#__"
  "Operations team"     = "Cloud operations"
  "Region"              = "South India"
  "Service class"       = "DV"
  "Data classification" = "Confidential"
  "ProvisionedType"     = "SharedZone"
}

global_settings = {
  default_region = "southindia"
  regions = {
    region1 = "southindia"
    region2 = "centralindia"
  }
  environment_name = "dv"
}

resource_groups = [
  {
    name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
  }
]

aad_groups = [
  "__#environment_abbr#__-__#service_id#__-__#environment_instance#___container_app_contributor"
]

virtual_networks = {
  vnet_main = {
    name                = "vnet-__#environment_abbr#__-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    address_space       = ["10.8.0.0/16"]
    # enable_ddos_protection_plan = true
    tags = {}
  }
}

subnets = {

  snet_container_env = {
    name                 = "snet-__#environment_abbr#__-__#service_id#__-ace-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name  = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    virtual_network_name = "vnet-__#environment_abbr#__-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"
    address_prefixes     = ["10.8.1.0/25"]
    service_endpoints    = []
    subnet_delegation = [
      {
        name         = "Microsoft.App.environments"
        service_name = "Microsoft.App/environments"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    ]
  }
}

virtual_network_peerings = {
  main_to_dv_vnet = {
    bidirectional                              = true
    source_virtual_network_name                = "vnet-__#environment_abbr#__-__#service_id#__-__#location_abbreviation#__-__#environment_instance#__"
    source_virtual_network_key                 = "vnet_main"
    source_virtual_network_resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    seperator                                  = "-TO-"
    peering_outgoing = {
      allow_forwarded_traffic = true
      allow_gateway_transit   = false
      use_remote_gateways     = false
    }
    peering_incoming = {
      allow_forwarded_traffic = true
      allow_gateway_transit   = true
      use_remote_gateways     = false
    }
  }
}

####################################################################
##############################--> PRIVATE DNS ZONE <--##############
####################################################################

private_dns_zones = [
  {
    dns_zone_name       = "privatelink.servicebus.windows.net"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    id                  = "servicebus"
    soa_records         = []
    records             = []
    cname_records       = []
    txt_records         = []
  },
  {
    dns_zone_name       = "privatelink.vaultcore.azure.net"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    id                  = "vaultcore"
    soa_records         = []
    records             = []
    cname_records       = []
    txt_records         = []
  },
  {
    dns_zone_name       = "privatelink.azurecr.io"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    id                  = "azurecr"
    soa_records         = []
    records             = []
    cname_records       = []
    txt_records         = []
  }
]

##************************************************************************************************************************************************
#                             Application insights
##************************************************************************************************************************************************
app_insights = [
  {
    name                 = "appi-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name  = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    daily_data_cap_in_gb = 100
    secret_management = {
      keyvault_name = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    }
  }
]

##************************************************************************************************************************************************
#                            Container Registry
##************************************************************************************************************************************************
container_registeries = {
  shared = {
    name                    = "acr__#environment_abbr#____#service_id#__shared__#location_abbreviation#____#environment_instance#__"
    resource_group_name     = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    location                = "uksouth"
    registery_sku           = "Standard"
    registery_admin_enabled = true
    tags                    = {}
    secret_management = {
      keyvault_name = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    }
  }
}

################**********************************************************************************************************************
#####                                                  Keyvault
################**********************************************************************************************************************
keyvaults = [
  {
    name                          = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    sku_name                      = "standard"
    enabled_for_disk_encryption   = "false"
    enable_purge_protection       = "true"
    resource_group_name           = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    tenant_id                     = "__#tenant_id#__"
    log_id                        = null
    public_network_access_enabled = false
  }
]

keyvault_private_endpoints = [
  {
    name                  = "pe-kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name   = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    keyvault_name         = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    subresource_names     = ["vault"]
    subnet_id             = null
    private_dns_zone_name = "privatelink.vaultcore.azure.net"
  }
]

keyvault_access_policies = [
  {
    keyvault_name           = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    name                    = "access_to_tf_spn"
    object_id               = "__#object_id#__"
    tenant_id               = "__#tenant_id#__"
    secret_permissions      = ["Delete", "Get", "List", "Purge", "Set", "Restore", "Recover", "Backup"]
    certificate_permissions = []
    key_permissions         = []
    storage_permissions     = []
  },
  {
    keyvault_name           = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    name                    = "access_to_container_app_contributor_group"
    object_id               = "azgrp-__#environment_abbr#__-__#service_id#__-__#environment_instance#___container_app_contributor"
    tenant_id               = "__#tenant_id#__"
    secret_permissions      = ["Get", "List"]
    certificate_permissions = []
    key_permissions         = []
    storage_permissions     = []
  }
]

keyvault_manual_secrets = [
  #   {
  #     name          = "service-email-account-username"
  #     keyvault_name = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
  #   },
  #   {
  #     name          = "service-email-account-password"
  #     keyvault_name = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
  #   }
]

##************************************************************************************************************************************************
#                             Servicebus namespaces
##************************************************************************************************************************************************

servicebus_namespaces = [
  {
    name                = "sb-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    sku                 = "Standard"
    capacity            = "1" // Uncomment this line when upgrading to Premium sku
    secret_management = {
      keyvault_name = "kv-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    }
    rbac = [
      {
        role_name      = "Azure Service Bus Data Owner"
        aad_group_name = "azgrp-__#environment_abbr#__-__#service_id#__-__#environment_instance#___container_app_contributor"
      }
    ]
  }
]


##************************************************************************************************************************************************
#                            App Container Environments
##************************************************************************************************************************************************
container_environments = [
  {
    name                         = "ace-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    resource_group_name          = "rg-__#environment_abbr#__-__#service_id#__-shared-__#location_abbreviation#__-__#environment_instance#__"
    log_analytics_workspace_name = "law-__#environment_abbr#__-__#service_id#__-landingzone-__#environment_instance#__"
    # workload_profile_type        = "Consumption"
    subnet_id = "snet_container_env"
    # internal_load_balancer_enabled = true
    tags = {
      Resource = "Azure Container Apps Environment"
      Type     = "Container Environment"
    }
  }
]
