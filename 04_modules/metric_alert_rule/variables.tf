variable "metric_alert_name" {
  description = "(Required) The name of the resource."
  type        = string
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) The name of the location where to create the resource."
  type        = string
}
variable "scopes" {
  description = "(Required) The Resources scope where the alert which will be created"
  default     = {}
}
variable "action_group_id" {
  type = string
}
variable "settings" {
  description = "(Required) alert common values for alert which will be created"
  default     = {}
}
variable "tags" {
  default = {}
}