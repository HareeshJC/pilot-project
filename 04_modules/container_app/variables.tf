variable "name" {
  description = "name - (Required) The name for this Container App. Changing this forces a new resource to be created."
  type        = string
}
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the resources will be created."
  nullable    = false
}
variable "container_app_environment_id" {
  description = "(Required) The ID of the Container App Environment within which this Container App should exist. Changing this forces a new resource to be created."
  type        = string
}
# variable "data_cr" {
#   default     = {}
#   description = "Fetches the Central Azure container registry information for the "
#   sensitive   = false
# }
variable "user_assigned_identity" {
  description = "user assigned identity to be used for the container app"
}
variable "revision_mode" {
  type = string
}

variable "workload_profile_name" {
  description = "(Optional) The name of the Workload Profile in the Container App Environment to place this Container App."
  type        = string
}
variable "tags" {
  type        = map(any)
  description = " (Optional) A mapping of tags for the resource to be inherited from the resource group."
  default     = {}
}

variable "settings" {
  default = {}
}

variable "container_apps" {
  description = "Map of container apps with their configurations."
  default     = []
}
