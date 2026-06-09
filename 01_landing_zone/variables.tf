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
#   type        = map(any)
# }

variable "managed_identities" {
  default = {}
  type    = map(any)
}

variable "log_analytics_workspace" {
  default     = []
  description = "Specifies the name of the Log Analytics Workspace"
  type        = list(any)
}