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

variable "tags" {
  type        = map(string)
  description = " (Optional) A mapping of tags which should be assigned to the AppService."
  default     = {}
}


variable "application_type" {
  type        = string
  description = "(Required) The Azure Region where the Service Plan should exist. Changing this forces a new AppService to be created"
  default     = "web"
}

variable "workspace_id" {
  type        = string
  description = "(Optional) Specifies the id of a log analytics workspace resource."
  default     = null
}

variable "daily_data_cap_in_gb" {
  type        = number
  description = "(Optional) SpecifiesSpecifies the Application Insights component daily data volume cap in GB"
}
