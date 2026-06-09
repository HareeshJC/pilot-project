## Variables for the Container Apps Managed Environment
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
}
variable "name" {
  description = "The name of the Container Apps Managed Environment. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
}
variable "resource_group_name" {
  description = "The name of the resource group in which the Container App Environment is to be created. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
}
# variable "workload_profile_type" {
#   description = <<-EOT
#   (Required) Workload profile type for the workloads to run on.
#              Possible values:-
#                               include Consumption,D4, D8, D16, D32, E4, E8, E16 and E32.      
#   EOT
#   type        = string
# }
# variable "workload_profile_name" {
#   description = "(Required) The name of the workload profile."
#   type        = string
# }
variable "log_analytics_workspace_id" {
  description = "The ID for the Log Analytics Workspace to link this Container Apps Managed Environment to. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
}
variable "infrastructure_subnet_id" {
  description = "The existing Subnet to use for the Container Apps Control Plane. Changing this forces a new resource to be created. "
  type        = string
  sensitive   = false
  default     = null
}
variable "internal_load_balancer_enabled" {
  description = "Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  sensitive   = false
  default     = false
}
variable "tags" {
  description = " A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
