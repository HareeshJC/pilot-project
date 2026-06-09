variable "name" {
  type        = string
  description = "The name of the Resource Group."
}

variable "location" {
  type        = string
  description = "The location/region where the resources will be created."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources."
}