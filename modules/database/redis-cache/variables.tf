variable "name" {
  description = "Name of the Redis cache. Must be globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Redis cache is created in."
  type        = string
}

variable "location" {
  description = "Azure region the Redis cache is deployed to."
  type        = string
}

variable "capacity" {
  description = "Size of the Redis cache. Valid range depends on family/sku_name (0-6 for C, 1-5 for P)."
  type        = number
  default     = 1
}

variable "family" {
  description = "SKU family of the Redis cache."
  type        = string
  default     = "C"

  validation {
    condition     = contains(["C", "P"], var.family)
    error_message = "family must be C (Basic/Standard) or P (Premium)."
  }
}

variable "sku_name" {
  description = "SKU name of the Redis cache."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "sku_name must be one of Basic, Standard, Premium."
  }
}

variable "minimum_tls_version" {
  description = "Minimum TLS version accepted by the Redis cache."
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of 1.0, 1.1, 1.2."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the Redis cache is enabled."
  type        = bool
  default     = false
}

variable "zones" {
  description = "Availability zones the Redis cache is deployed across. Only supported by the Premium SKU."
  type        = list(string)
  default     = []
}

variable "redis_configuration" {
  description = "Redis server configuration, including optional RDB/AOF backup settings. Storage connection strings are sensitive and only used by the Premium SKU."
  type = object({
    maxmemory_policy                = optional(string, "volatile-lru")
    enable_authentication           = optional(bool, true)
    rdb_backup_enabled              = optional(bool, false)
    rdb_backup_frequency            = optional(number, 60)
    rdb_backup_max_snapshot_count   = optional(number, 1)
    rdb_storage_connection_string   = optional(string, null)
    aof_backup_enabled              = optional(bool, false)
    aof_storage_connection_string_0 = optional(string, null)
    aof_storage_connection_string_1 = optional(string, null)
  })
  default   = {}
  sensitive = true
}

variable "patch_schedules" {
  description = "List of maintenance patch schedules for the Redis cache. Only supported by the Premium SKU."
  type = list(object({
    day_of_week        = string
    start_hour_utc     = optional(number, 0)
    maintenance_window = optional(string, null)
  }))
  default = []
}

variable "firewall_rules" {
  description = "Map of firewall rules to create, keyed by rule name."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "linked_servers" {
  description = "Map of linked Redis caches for geo-replication, keyed by linked server name. Only supported by the Premium SKU."
  type = map(object({
    linked_redis_cache_id       = string
    linked_redis_cache_location = string
    server_role                 = optional(string, "Secondary")
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
