variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Azure Container Registry. Changing this forces a new Azure Container Registry to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the  Azure Container Registry exist. Changing this forces a new  Azure Container Registry to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the  Azure Container Registry should exist. Changing this forces a new  Azure Container Registry to be created"
}
variable "user_assigned_identity" {
  description = "description"
}
variable "aad_groups" {
  default = {}
}

variable "tags" {
  type        = map(string)
  description = " (Optional) A mapping of tags which should be assigned to the  Azure Container Registry"
  default     = {}
}

variable "settings" {
  type = object({
    registery_sku           = optional(string, "Standard")
    registery_admin_enabled = optional(bool, true)
  })

  description = <<-EOT
        provision sku value for automation account as defined below:
        ```
            {
                registery_sku          = (Required) Defines which tier to use. Options are Standard or Premium. Please note that setting this field to Free will force the creation of a new resource
                registery_admin_enabled = (Required) Defines the admin mode enabled .
            }
        ```
    EOT
}
