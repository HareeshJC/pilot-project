variable "name" {
  type        = string
  description = <<EOT
      (Required) Specifies the name of the Key Vault. Changing this forces a new resource to be created. 
       The name must be globally unique. 
       If the vault is in a recoverable state then the vault will need to be purged before reusing the name.
  EOT
}

variable "location" {
  type        = string
  default     = null
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
}

variable "settings" {}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}
variable "tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
}


variable "diagnostics" {
  default     = null
  description = "(Required) Diagnostics object with the definitions and destination services"
}

