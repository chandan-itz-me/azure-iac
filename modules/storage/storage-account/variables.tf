variable "name" {
  description = "Name of the storage account. Must be globally unique, lowercase alphanumeric, 3-24 characters."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the storage account is created in."
  type        = string
}

variable "location" {
  description = "Azure region the storage account is deployed to."
  type        = string
}

variable "account_kind" {
  description = "Kind of storage account."
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage"], var.account_kind)
    error_message = "account_kind must be one of Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage."
  }
}

variable "account_tier" {
  description = "Performance tier of the storage account."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "Replication strategy for the storage account."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "min_tls_version" {
  description = "Minimum TLS version accepted by the storage account."
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "min_tls_version must be one of TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the storage account is enabled. Disabled by default; use private endpoints or network_rules for access."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Whether Shared Key authorization is allowed. Prefer disabling this and using Azure AD (RBAC) authentication where possible."
  type        = bool
  default     = true
}

variable "https_traffic_only_enabled" {
  description = "Whether only HTTPS traffic is permitted to the storage account."
  type        = bool
  default     = true
}

variable "network_rules" {
  description = "Network rules restricting access to the storage account. Set to null to disable network rules entirely (not recommended)."
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(list(string), ["AzureServices"])
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {}
}

variable "blob_properties" {
  description = "Blob service properties for the storage account."
  type = object({
    versioning_enabled              = optional(bool, true)
    change_feed_enabled             = optional(bool, false)
    delete_retention_days           = optional(number, 7)
    container_delete_retention_days = optional(number, 7)
  })
  default = {}
}

variable "containers" {
  description = "Map of blob containers to create, keyed by container name."
  type = map(object({
    container_access_type = optional(string, "private")
  }))
  default = {}
}

variable "file_shares" {
  description = "Map of file shares to create, keyed by share name."
  type = map(object({
    quota_gb = number
  }))
  default = {}
}

variable "queues" {
  description = "Map of storage queues to create, keyed by queue name."
  type        = map(object({}))
  default     = {}
}

variable "tables" {
  description = "Map of storage tables to create, keyed by table name."
  type        = map(object({}))
  default     = {}
}

variable "customer_managed_key" {
  description = "Optional customer-managed key configuration for encryption at rest. Requires a user-assigned identity with access to the key vault."
  type = object({
    enabled                   = bool
    key_vault_id              = string
    key_name                  = string
    key_version               = optional(string)
    user_assigned_identity_id = string
  })
  default = {
    enabled                   = false
    key_vault_id              = null
    key_name                  = null
    key_version               = null
    user_assigned_identity_id = null
  }
}

variable "lifecycle_rules" {
  description = "Map of blob lifecycle management rules, keyed by rule name."
  type = map(object({
    prefix_match               = optional(list(string), [])
    tier_to_cool_after_days    = optional(number, null)
    tier_to_archive_after_days = optional(number, null)
    delete_after_days          = optional(number, null)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
