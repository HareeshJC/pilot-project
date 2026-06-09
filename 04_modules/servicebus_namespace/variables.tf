variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Service Plan. Changing this forces a new AppService to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the AppService should exist. Changing this forces a new AppService to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Service Plan should exist. Changing this forces a new AppService to be created"
}
variable "aad_groups" {
  description = "Map of AAD groups with their object IDs."
  type = map(object({
    object_id = string
  }))
}
variable "tags" {
  type        = map(string)
  description = " (Optional) A mapping of tags which should be assigned to the AppService."
  default     = {}
}

variable "settings" {
  type = object({
    sku                           = optional(string, "Standard")
    capacity                      = optional(string, "0")
    local_auth_enabled            = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
    minimum_tls_version           = optional(string, "1.2")
    rbac = optional(list(object({
      role_name      = string
      resource_id    = optional(string)
      aad_group_name = optional(string, "")
    })))
  })
  description = <<-EOT
        One or more gateway_ip_configuration blocks as defined below:
        ```

            {
                sku                                   = (Required) Defines which tier to use. Options are Basic, Standard or Premium. Please note that setting this field to Premium will force the creation of a new resource
                capacity                              = (Optional) Specifies the capacity. When sku is Premium, capacity can be 1, 2, 4, 8 or 16. When sku is Basic or Standard, capacity can be 0 only.
                local_auth_enabled                    = (Optional) Whether or not SAS authentication is enabled for the Service Bus namespace. Defaults to true
                public_network_access_enabled         = (Optional) Is public network access enabled for the Service Bus Namespace? Defaults to true
                minimum_tls_version                   = (Optional) The minimum supported TLS version for this Service Bus Namespace. Valid values are: 1.0, 1.1 and 1.2. The current default minimum TLS version is 1.2
            }
        rbac = [
            {
                role_name      = "Azure Service Bus Data Owner"
                resource_id    = "(Optional) The Id of the resources"
                aad_group_name = "(Optional)aad group name ex:azgrp_sub_int-__#environment_abbr#__-__#service_id#__-01function_app_contributor"
            }
        ]
        ```
    EOT
}
