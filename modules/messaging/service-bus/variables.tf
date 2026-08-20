variable "name" {
  description = "Name of the Service Bus namespace."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Service Bus namespace is created in."
  type        = string
}

variable "location" {
  description = "Azure region the Service Bus namespace is deployed to."
  type        = string
}

variable "sku" {
  description = "Pricing tier of the Service Bus namespace."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of Basic, Standard, Premium."
  }
}

variable "capacity" {
  description = "Messaging units for the Premium sku (1, 2, 4, 8 or 16). Ignored for Basic/Standard."
  type        = number
  default     = 1

  validation {
    condition     = contains([1, 2, 4, 8, 16], var.capacity)
    error_message = "capacity must be one of 1, 2, 4, 8, 16."
  }
}

variable "zone_redundant" {
  description = "Whether availability zones are enabled. Only supported on the Premium sku."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the namespace is enabled. Disabled by default; use private endpoints or the network_rule_set for controlled access."
  type        = bool
  default     = false
}

variable "network_rule_set" {
  description = "Network rule set restricting access to the namespace. Only supported on the Premium sku."
  type = object({
    default_action           = optional(string, "Deny")
    trusted_services_allowed = optional(bool, false)
    ip_rules                 = optional(list(string), [])
    virtual_network_rules = optional(list(object({
      subnet_id                                       = string
      ignore_missing_virtual_network_service_endpoint = optional(bool, false)
    })), [])
  })
  default = null
}

variable "identity" {
  description = "Managed identity configuration for the namespace."
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "identity.type must be one of SystemAssigned, UserAssigned, \"SystemAssigned, UserAssigned\"."
  }
}

variable "enable_disaster_recovery_config" {
  description = "Whether a geo-disaster recovery (namespace pairing) alias is created for the namespace."
  type        = bool
  default     = false
}

variable "disaster_recovery_alias_name" {
  description = "Alias name for the geo-disaster recovery configuration. Required when enable_disaster_recovery_config is true."
  type        = string
  default     = null
}

variable "disaster_recovery_partner_namespace_id" {
  description = "ID of the partner namespace to pair with for geo-disaster recovery. Required when enable_disaster_recovery_config is true."
  type        = string
  default     = null
}

variable "queues" {
  description = "Map of Service Bus queues to create, keyed by queue name."
  type = map(object({
    max_size_in_megabytes                   = optional(number, 1024)
    default_message_ttl                     = optional(string, null)
    lock_duration                           = optional(string, null)
    dead_lettering_on_message_expiration    = optional(bool, true)
    requires_duplicate_detection            = optional(bool, false)
    duplicate_detection_history_time_window = optional(string, null)
    requires_session                        = optional(bool, false)
    enable_partitioning                     = optional(bool, false)
    max_delivery_count                      = optional(number, 10)
  }))
  default = {}
}

variable "topics" {
  description = "Map of Service Bus topics to create, keyed by topic name."
  type = map(object({
    max_size_in_megabytes                   = optional(number, 1024)
    default_message_ttl                     = optional(string, null)
    requires_duplicate_detection            = optional(bool, false)
    duplicate_detection_history_time_window = optional(string, null)
    enable_partitioning                     = optional(bool, false)
    subscriptions = optional(map(object({
      max_delivery_count                   = optional(number, 10)
      lock_duration                        = optional(string, null)
      default_message_ttl                  = optional(string, null)
      dead_lettering_on_message_expiration = optional(bool, true)
      requires_session                     = optional(bool, false)
      forward_to                           = optional(string, null)
      rules = optional(map(object({
        filter_type = string
        sql_filter  = optional(string, null)
        correlation_filter = optional(object({
          correlation_id = optional(string, null)
          label          = optional(string, null)
          message_id     = optional(string, null)
          reply_to       = optional(string, null)
          session_id     = optional(string, null)
          to             = optional(string, null)
        }), null)
      })), {})
    })), {})
  }))
  default = {}
}

variable "authorization_rules" {
  description = "Map of namespace-level authorization rules to create, keyed by rule name."
  type = map(object({
    listen = optional(bool, true)
    send   = optional(bool, false)
    manage = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
