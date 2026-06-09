variable "topic_name" {
  type        = string
  description = "(Required) Specifies the name of the ServiceBus Topic resource. Changing this forces a new resource to be created."
}

variable "namespace_id" {
  type        = string
  description = "(Required) The ID of the ServiceBus Namespace to create Changing this forces a new resource to be created. this topic in. Changing this forces a new resource to be created."
}

variable "settings" {
  default = {}
}