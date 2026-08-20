variable "name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the workspace is created in."
  type        = string
}

variable "location" {
  description = "Azure region the workspace is deployed to."
  type        = string
}

variable "sku" {
  description = "Pricing tier of the workspace."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Number of days to retain workspace data, between 30 and 730."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "retention_in_days must be between 30 and 730."
  }
}

variable "daily_quota_gb" {
  description = "Daily ingestion cap in GB. Use -1 for unlimited (default provider behaviour)."
  type        = number
  default     = null
}

variable "internet_ingestion_enabled" {
  description = "Whether data ingestion over the public internet is allowed. Defaults to true for compatibility; tighten to false and use a private link scope for stricter environments."
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "Whether querying the workspace over the public internet is allowed. Defaults to true for compatibility; tighten to false and use a private link scope for stricter environments."
  type        = bool
  default     = true
}

variable "solutions" {
  description = "Map of Log Analytics solutions to link to the workspace, keyed by an arbitrary name (e.g. \"security\", \"container-insights\")."
  type = map(object({
    solution_name = string
    publisher     = string
    product       = string
  }))
  default = {}
}

variable "linked_service" {
  description = "Automation account linked service configuration for the workspace."
  type = object({
    automation_account_id = string
  })
  default = null
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
