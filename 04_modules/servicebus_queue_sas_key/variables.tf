variable "sharedaccesskey_name" {
  type        = string
  description = "(Required) The name which should be used for this Service Bus SAS. Changing this forces a new Service Bus SAS to be created."
}

variable "servicebus_queue_id" {
  type        = string
  description = "(Required) The ID of the Service Bus Topic for which this SAS should be created. Changing this forces a new Service Bus SAS to be created."
}

variable "listen" {
  type        = bool
  description = "(Required) Whether or not to grant Listen permissions to this SAS."
}

variable "send" {
  type        = bool
  description = "(Required) Whether or not to grant Send permissions to this SAS."
}

variable "manage" {
  type        = bool
  description = "(Required) Whether or not to grant Manage permissions to this SAS."
}