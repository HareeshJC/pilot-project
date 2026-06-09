variable "key_vault_id" {
  type        = string
  description = "(Required) The ID of the key vault to which the access policy applies."
}

variable "settings" {}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "aad_groups" {
  default     = null
  description = "aad group objects"
}