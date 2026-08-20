variable "resource_group_name" {
  description = "Name of the resource group the alert and action group resources are created in."
  type        = string
}

variable "location" {
  description = "Azure region the log-based scheduled query rules are deployed to. Not used by metric alerts, activity log alerts or action groups, which are regionless."
  type        = string
  default     = null
}

variable "action_groups" {
  description = "Map of action groups to create, keyed by an arbitrary name."
  type = map(object({
    name       = string
    short_name = string

    email_receiver = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool, true)
    })), [])

    sms_receiver = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })), [])

    webhook_receiver = optional(list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = optional(bool, true)
    })), [])

    azure_function_receiver = optional(list(object({
      name                     = string
      function_app_resource_id = string
      function_name            = string
      http_trigger_url         = string
      use_common_alert_schema  = optional(bool, true)
    })), [])
  }))
  default = {}
}

variable "metric_alerts" {
  description = "Map of metric alerts to create, keyed by an arbitrary name."
  type = map(object({
    name             = string
    scopes           = list(string)
    description      = optional(string, null)
    severity         = optional(number, 3)
    frequency        = optional(string, "PT1M")
    window_size      = optional(string, "PT5M")
    auto_mitigate    = optional(bool, true)
    enabled          = optional(bool, true)
    action_group_ids = optional(list(string), [])

    criteria = optional(list(object({
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = number
      dimension = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
    })), [])

    dynamic_criteria = optional(list(object({
      metric_namespace         = string
      metric_name              = string
      aggregation              = string
      operator                 = string
      alert_sensitivity        = string
      evaluation_total_count   = optional(number, 4)
      evaluation_failure_count = optional(number, 4)
    })), [])
  }))
  default = {}
}

variable "activity_log_alerts" {
  description = "Map of activity log alerts to create, keyed by an arbitrary name."
  type = map(object({
    name        = string
    scopes      = list(string)
    description = optional(string, null)
    enabled     = optional(bool, true)

    criteria = object({
      category       = string
      operation_name = optional(string, null)
      resource_type  = optional(string, null)
      status         = optional(string, null)
      level          = optional(string, null)
    })

    action_group_ids = optional(list(string), [])
  }))
  default = {}
}

variable "scheduled_query_rules" {
  description = "Map of log-based scheduled query rule alerts (v2) to create, keyed by an arbitrary name."
  type = map(object({
    name                    = string
    scopes                  = list(string)
    description             = optional(string, null)
    severity                = optional(number, 3)
    evaluation_frequency    = optional(string, "PT5M")
    window_duration         = optional(string, "PT5M")
    auto_mitigation_enabled = optional(bool, true)
    enabled                 = optional(bool, true)
    action_group_ids        = optional(list(string), [])

    criteria = object({
      query                   = string
      time_aggregation_method = string
      threshold               = number
      operator                = string
      dimension = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
    })
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
