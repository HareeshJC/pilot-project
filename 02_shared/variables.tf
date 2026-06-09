variable "tenant_id" {
  type        = string
  description = "azure tenant Id"
}
variable "subscription_id" {
  type        = string
  description = "azure subscription Id"
}

variable "remote_state_backend_storage_account_name" {
  type        = string
  description = "remote backend storage account name"
}
variable "remote_state_backend_storage_account_contianer_name" {
  type        = string
  description = "remote backend storage account container name"
}
variable "remote_state_backend_state_file_name" {
  type        = string
  description = "remote backend state file name"
}

variable "remote_state_backend_resource_group_name" {
  type        = string
  description = "remote backend storage account resource group name"
}

variable "remote_state_backend_subscription_id" {
  type        = string
  description = "remote backend subscription Id"
}


variable "location" {
  description = "environment location"
  type        = string
}

variable "global_settings" {
  description = "environment specific global settings"
  type = object({
    default_region   = string
    regions          = map(string)
    environment_name = string
  })
}

variable "shared_tags" {
  default     = {}
  description = "map of tags to be applied to all resources"
  type        = map(string)
}

variable "resource_groups" {
  description = "map of resource groups to be created"
  default     = []
  type        = list(any)
}

# variable "resource_group_roles" {
#   description = "map of resource groups roles to be created"
#   default     = {}
#   type = list(any)
# }

# variable "private_dns_rg_name" {
#   description = "map of aad apps to be created"
#   type        = string
#   default     = null
# }

#################**********************************************************************************************************************
######                                                  Network Block
#################**********************************************************************************************************************


variable "virtual_networks" {
  default = {}
  type    = map(any)
}

variable "subnets" {
  default = {}
  type    = map(any)
}

variable "hub_virtual_network_name" {
  default = null
  type    = string
}

variable "hub_virtual_network_subnet_name" {
  default = null
  type    = string
}
variable "hub_virtual_network_rg_name" {
  default = null
  type    = string
}

variable "virtual_network_peerings" {
  default = {}
  type    = map(any)
}

variable "app_insights" {

  default     = []
  description = "application insights"
  type        = list(any)
}

variable "private_dns_zones" {
  default     = []
  description = "map of private DNS zone to be created for the app service environment"
  type        = list(any)
}

#################**********************************************************************************************************************
######                                                  AAD Block
#################**********************************************************************************************************************
variable "aad_groups" {
  description = "map of aad apps to be created"
  default     = []
  type        = list(string)
}

##************************************************************************************************************************************************
#                            Azure Container Registry
##************************************************************************************************************************************************

variable "container_registeries" {
  default     = {}
  description = "list of azure container registries"
  type        = map(any)
}

#################**********************************************************************************************************************
######                                                  KEYVAULTS
#################**********************************************************************************************************************
variable "keyvaults" {
  description = "map of keyvaults to be created"
  default     = []
  type        = list(any)
}

variable "keyvault_private_endpoints" {
  description = "list of keyvault private endpoints to be created"
  default     = []
  type        = list(any)
}

variable "keyvault_manual_secrets" {
  description = "list of secret keys with predetermined values"
  default     = []
  type        = list(any)
}

variable "keyvault_access_policies" {
  description = "list of application specific key vault access policies"
  default     = []
  type        = list(any)
}

##************************************************************************************************************************************************
#                             ServiceBus Namespace
##************************************************************************************************************************************************

variable "servicebus_namespaces" {
  default     = []
  description = "list of service bus namespaces to be created"
  type        = list(any)
}


variable "container_environments" {
  description = "Manages a Container App Environment."
  default     = []
  type        = list(any)
}