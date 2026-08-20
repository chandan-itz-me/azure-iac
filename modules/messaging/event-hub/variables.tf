variable "name" {
  description = "Name of the Event Hubs namespace."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Event Hubs namespace is created in."
  type        = string
}

variable "location" {
  description = "Azure region the Event Hubs namespace is deployed to."
  type        = string
}

variable "sku" {
  description = "Pricing tier of the Event Hubs namespace."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium", "Dedicated"], var.sku)
    error_message = "sku must be one of Basic, Standard, Premium, Dedicated."
  }
}

variable "capacity" {
  description = "Throughput units (Basic/Standard) or processing units (Premium) provisioned for the namespace."
  type        = number
  default     = 1
}

variable "auto_inflate_enabled" {
  description = "Whether auto-inflate of throughput units is enabled. Not supported on Dedicated."
  type        = bool
  default     = false
}

variable "maximum_throughput_units" {
  description = "Maximum number of throughput units the namespace auto-inflates to. Required when auto_inflate_enabled is true, between 1 and 20."
  type        = number
  default     = null

  validation {
    condition     = var.maximum_throughput_units == null || (var.maximum_throughput_units >= 1 && var.maximum_throughput_units <= 20)
    error_message = "maximum_throughput_units must be between 1 and 20."
  }
}

variable "zone_redundant" {
  description = "Whether availability zones are enabled for the namespace."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the namespace is enabled. Disabled by default; use private endpoints or network_rulesets for controlled access."
  type        = bool
  default     = false
}

variable "network_rulesets" {
  description = "Network rule set restricting access to the namespace."
  type = object({
    default_action                 = optional(string, "Deny")
    trusted_service_access_enabled = optional(bool, false)
    ip_rule = optional(list(object({
      ip_mask = string
      action  = optional(string, "Allow")
    })), [])
    virtual_network_rule = optional(list(object({
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

variable "eventhubs" {
  description = "Map of event hubs to create within the namespace, keyed by event hub name."
  type = map(object({
    partition_count   = optional(number, 2)
    message_retention = optional(number, 1)
    capture_description = optional(object({
      enabled             = optional(bool, true)
      encoding            = optional(string, "Avro")
      interval_in_seconds = optional(number, 300)
      size_limit_in_bytes = optional(number, 314572800)
      skip_empty_archives = optional(bool, true)
      storage_account_id  = string
      blob_container_name = string
      archive_name_format = optional(string, "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}")
    }), null)
  }))
  default = {}
}

variable "consumer_groups" {
  description = "Map of consumer groups to create, keyed by an arbitrary name. Each entry references the event hub it belongs to via eventhub_name."
  type = map(object({
    eventhub_name = string
    user_metadata = optional(string, null)
  }))
  default = {}
}

variable "authorization_rules" {
  description = "Map of per-event-hub authorization rules to create, keyed by an arbitrary name. Each entry references the event hub it applies to via eventhub_name."
  type = map(object({
    eventhub_name = string
    listen        = optional(bool, true)
    send          = optional(bool, false)
    manage        = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
