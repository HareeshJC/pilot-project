variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone. Must be a valid domain name."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the resources will be created."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "soa_records" {
  type = list(object({
    email        = string
    expire_time  = number
    minimum_ttl  = number
    refresh_time = number
    retry_time   = number
    ttl          = number
    tags         = map(string)
  }))

  default = []
}

variable "virtual_network_links" {
  type = list(object({
    virtual_network_id   = string
    registration_enabled = bool
  }))

  default = []
}

variable "records" {
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
  }))

  default = []
}

variable "txt_records" {
  type = list(object({
    name  = string
    ttl   = number
    value = string
  }))

  default = []
}

variable "cname_records" {
  type = list(object({
    name   = string
    ttl    = number
    record = string
  }))

  default = []
}