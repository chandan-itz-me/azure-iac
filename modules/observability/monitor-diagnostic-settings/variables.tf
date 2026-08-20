variable "diagnostic_settings" {
  description = "Map of diagnostic settings to create, keyed by a logical name. Each entry must set exactly one of log_analytics_workspace_id, storage_account_id or eventhub_authorization_rule_id as its destination."
  type = map(object({
    target_resource_id             = string
    log_analytics_workspace_id     = optional(string, null)
    storage_account_id             = optional(string, null)
    eventhub_authorization_rule_id = optional(string, null)
    eventhub_name                  = optional(string, null)

    enabled_logs = optional(list(object({
      category       = optional(string, null)
      category_group = optional(string, null)
    })), [])

    metrics = optional(list(object({
      category = string
      enabled  = optional(bool, true)
    })), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.diagnostic_settings :
      length(compact([v.log_analytics_workspace_id, v.storage_account_id, v.eventhub_authorization_rule_id])) == 1
    ])
    error_message = "Each diagnostic setting must set exactly one of log_analytics_workspace_id, storage_account_id or eventhub_authorization_rule_id."
  }
}
