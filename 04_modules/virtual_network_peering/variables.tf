variable "source_virtual_network_name" {
  type        = string
  description = "(Required) The name of the virtual network peering. Changing this forces a new resource to be created."
}

variable "source_virtual_network_id" {
  type        = string
  description = "(Required) The ID of the source virtual network. Changing this forces a new resource to be created."
}
variable "source_virtual_network_resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created."
}

variable "target_virtual_network_name" {
  type        = string
  description = "(Required) The name of the target virtual network. Changing this forces a new resource to be created."
}
variable "target_virtual_network_id" {
  type        = string
  description = "(Required) The ID of the target virtual network. Changing this forces a new resource to be created."
}

variable "target_virtual_network_resource_group_name" {
  type        = string
  description = "(Required) The name of the target virtual network resource group name"
}

variable "seperator" {
  type        = string
  default     = "-"
  description = "value"
}

variable "settings" {
}
variable "bidirectional" {
  type        = bool
  default     = false
  description = "peer VNets across subscriptions and across regions"
}
variable "diagnostics" {
  default     = ""
  description = "(Required) Diagnostics object with the definitions and destination services"
}