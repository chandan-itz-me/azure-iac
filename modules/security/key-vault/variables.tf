variable "name" {
  description = "Name of the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Key Vault is created in."
  type        = string
}

variable "location" {
  description = "Azure region the Key Vault is deployed to."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID the Key Vault trusts for authentication."
  type        = string
}

variable "sku_name" {
  description = "SKU of the Key Vault."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be one of: standard, premium."
  }
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled. Once enabled this cannot be disabled."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Number of days that soft-deleted items are retained, between 7 and 90."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "public_network_access_enabled" {
  description = "Whether the Key Vault is reachable from the public internet, subject to network_acls."
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Whether Azure RBAC is used to authorize data plane access instead of access policies. Preferred over access policies."
  type        = bool
  default     = true
}

variable "access_policies" {
  description = "Map of access policies, keyed by a unique name. Only applied when enable_rbac_authorization is false."
  type = map(object({
    object_id               = string
    application_id          = optional(string)
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}

variable "network_acls" {
  description = "Network ACL rules restricting access to the Key Vault."
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(string, "AzureServices")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {}
}

variable "keys" {
  description = "Map of keys to create in the Key Vault, keyed by a unique key name."
  type = map(object({
    key_type = string
    key_size = optional(number)
    curve    = optional(string)
    key_opts = list(string)
    rotation_policy = optional(object({
      expire_after         = optional(string)
      notify_before_expiry = optional(string)
      automatic_renew_days = optional(number)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
