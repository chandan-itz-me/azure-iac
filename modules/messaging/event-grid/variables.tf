variable "name" {
  description = "Name of the Event Grid topic or domain."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Event Grid resource is created in."
  type        = string
}

variable "location" {
  description = "Azure region the Event Grid resource is deployed to."
  type        = string
}

variable "create_domain" {
  description = "Whether to create an Event Grid domain (for many topics) instead of a single custom topic."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the topic or domain is enabled. Disabled by default; use private endpoints for access instead."
  type        = bool
  default     = false
}

variable "input_schema" {
  description = "Schema in which events are published to the topic or domain."
  type        = string
  default     = "EventGridSchema"

  validation {
    condition     = contains(["EventGridSchema", "CustomEventSchema", "CloudEventSchemaV1_0"], var.input_schema)
    error_message = "input_schema must be one of EventGridSchema, CustomEventSchema, CloudEventSchemaV1_0."
  }
}

variable "identity" {
  description = "Managed identity configuration for the topic or domain."
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

variable "event_subscriptions" {
  description = "Map of event subscriptions to create against the topic or domain, keyed by subscription name."
  type = map(object({
    endpoint_type = string

    webhook_endpoint_url = optional(string, null)
    eventhub_id          = optional(string, null)
    servicebus_queue_id  = optional(string, null)
    servicebus_topic_id  = optional(string, null)
    azure_function_id    = optional(string, null)
    storage_queue = optional(object({
      storage_account_id = string
      queue_name         = string
    }), null)

    included_event_types = optional(list(string), null)

    subject_filter = optional(object({
      subject_begins_with = optional(string, null)
      subject_ends_with   = optional(string, null)
      case_sensitive      = optional(bool, false)
    }), null)

    dead_letter_storage_blob = optional(object({
      storage_account_id          = string
      storage_blob_container_name = string
    }), null)

    retry_policy = optional(object({
      max_delivery_attempts         = optional(number, 30)
      event_time_to_live_in_minutes = optional(number, 1440)
    }), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.event_subscriptions :
      contains(["webhook", "eventhub", "servicebus_queue", "servicebus_topic", "storage_queue", "azure_function"], v.endpoint_type)
    ])
    error_message = "endpoint_type must be one of webhook, eventhub, servicebus_queue, servicebus_topic, storage_queue, azure_function."
  }
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
