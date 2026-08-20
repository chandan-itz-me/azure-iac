variable "name" {
  description = "Name of the Cosmos DB account. Must be globally unique, lowercase alphanumeric and hyphens."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Cosmos DB account is created in."
  type        = string
}

variable "location" {
  description = "Azure region the Cosmos DB account's primary write location is deployed to."
  type        = string
}

variable "offer_type" {
  description = "Offer type for the Cosmos DB account."
  type        = string
  default     = "Standard"
}

variable "api" {
  description = "Cosmos DB API surface to expose. Determines the account kind and enabled capabilities."
  type        = string
  default     = "Sql"

  validation {
    condition     = contains(["Sql", "MongoDB", "Cassandra", "Gremlin", "Table"], var.api)
    error_message = "api must be one of Sql, MongoDB, Cassandra, Gremlin, Table."
  }
}

variable "consistency_policy" {
  description = "Default consistency policy for the Cosmos DB account."
  type = object({
    consistency_level       = optional(string, "Session")
    max_interval_in_seconds = optional(number, 5)
    max_staleness_prefix    = optional(number, 100)
  })
  default = {}

  validation {
    condition     = contains(["Strong", "BoundedStaleness", "Session", "ConsistentPrefix", "Eventual"], var.consistency_policy.consistency_level)
    error_message = "consistency_policy.consistency_level must be one of Strong, BoundedStaleness, Session, ConsistentPrefix, Eventual."
  }
}

variable "geo_locations" {
  description = "Map of geo-replicated locations, keyed by Azure region name."
  type = map(object({
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
}

variable "is_virtual_network_filter_enabled" {
  description = "Whether virtual network filtering is enabled for the Cosmos DB account."
  type        = bool
  default     = false
}

variable "virtual_network_rules" {
  description = "List of subnet IDs allowed to access the Cosmos DB account when virtual network filtering is enabled."
  type = list(object({
    subnet_id                            = string
    ignore_missing_vnet_service_endpoint = optional(bool, false)
  }))
  default = []
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the Cosmos DB account is enabled."
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "Whether automatic failover is enabled for the Cosmos DB account."
  type        = bool
  default     = true
}

variable "multiple_write_locations_enabled" {
  description = "Whether multiple write locations (multi-region writes) are enabled."
  type        = bool
  default     = false
}

variable "backup" {
  description = "Backup configuration for the Cosmos DB account. Continuous backup ignores interval/retention/storage_redundancy; periodic backup ignores tier."
  type = object({
    type                = optional(string, "Periodic")
    interval_in_minutes = optional(number, 240)
    retention_in_hours  = optional(number, 8)
    storage_redundancy  = optional(string, "Local")
    tier                = optional(string, "Continuous7Days")
  })
  default = {}

  validation {
    condition     = contains(["Continuous", "Periodic"], var.backup.type)
    error_message = "backup.type must be Continuous or Periodic."
  }
}

variable "sql_databases" {
  description = "Map of SQL API databases and their containers, keyed by database name."
  type = map(object({
    throughput               = optional(number, null)
    autoscale_max_throughput = optional(number, null)
    containers = optional(map(object({
      partition_key_path       = string
      throughput               = optional(number, null)
      autoscale_max_throughput = optional(number, null)
      indexing_policy = optional(object({
        indexing_mode  = optional(string, "consistent")
        included_paths = optional(list(string), ["/*"])
        excluded_paths = optional(list(string), [])
      }), null)
      unique_keys = optional(list(list(string)), [])
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
