variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Alert Action Group. Changing this forces a new Alert Action Group to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the  Alert Action Group exist. Changing this forces a new  Alert Action Group to be created."
}

variable "short_name" {
  type        = string
  description = "(Required) The short name for the alert action group. Changing this forces a new alert action group to be created."
}

# variable "automation_runbook_receiver" {
#   description = "Optional automation runbook receiver"

#   type = object({
#     name                    = string
#     automation_account_id   = string
#     runbook_name            = string
#     webhook_resource_id     = string
#     is_global_runbook       = bool
#     service_uri             = string
#     use_common_alert_schema = bool
#   })

#   default = {}
# }