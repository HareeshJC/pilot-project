variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Private Endpoint. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = null
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}
variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the subnet to which the private endpoint will be connected. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Private Endpoint. Changing this forces a new resource to be created."
}
variable "resource_id" {
  type        = string
  description = "(Required) The ID of the resource to which the private endpoint will connect. Changing this forces a new resource to be created."
}
variable "private_dns_zone_ids" {
  type        = list(string)
  description = "(Required) The IDs of the private DNS zones to which the private endpoint will be associated. Changing this forces a new resource to be created."
}
variable "settings" {
  type        = any
  description = "(Optional) A settings object to configure additional properties of the private endpoint."
}
variable "tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}

