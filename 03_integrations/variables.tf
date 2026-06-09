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
variable "shared_remote_state_backend_state_file_name" {
  type        = string
  description = "remote backend state file name"
}

variable "landing_zone_remote_state_backend_state_file_name" {
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
  default = {}
  type    = map(string)
}


variable "resource_groups" {
  description = "map of resource groups to be created"
  default     = []
  type        = list(any)
}

# variable "resource_group_roles" {
#   description = "map of resource groups roles to be created"
#   default     = {}
#   type        = list(any)
# }

variable "servicebus_queues" {
  description = "Map of servicebus queues with their configurations."
  default     = []
  type        = list(any)
}

variable "servicebus_queue_sas" {
  description = "Map of servicebus queues sas with their configurations."
  default     = []
  type        = list(any)
}

variable "container_apps" {
  description = "Map of container apps with their configurations."
  default     = []
  type        = list(any)
}

variable "alert_common" {
  description = "Map of common alert vars"
  default     = {}
  type        = map(string)
}

variable "alerts" {
  description = "List of alerts which will be created"
  default     = []
  type        = list(any)
}

variable "alert_action_groups" {
  default     = []
  description = "Map of alert action groups with their configurations."
  type        = list(any)
}
