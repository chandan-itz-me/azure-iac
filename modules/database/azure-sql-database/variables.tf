variable "name" {
  description = "Name of the SQL server. Must be globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the SQL server is created in."
  type        = string
}

variable "location" {
  description = "Azure region the SQL server is deployed to."
  type        = string
}

variable "administrator_login" {
  description = "SQL authentication administrator login name. Leave null when using an Azure AD-only administrator."
  type        = string
  default     = null
}

variable "administrator_login_password" {
  description = "SQL authentication administrator password. Leave null when using an Azure AD-only administrator. Never default this to a literal value."
  type        = string
  default     = null
  sensitive   = true
}

variable "azuread_administrator" {
  description = "Azure AD administrator configuration for the SQL server. Preferred over SQL authentication."
  type = object({
    login_username              = string
    object_id                   = string
    tenant_id                   = optional(string, null)
    azuread_authentication_only = optional(bool, false)
  })
  default = null
}

variable "minimum_tls_version" {
  description = "Minimum TLS version accepted by the SQL server."
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of 1.0, 1.1, 1.2."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the SQL server is enabled."
  type        = bool
  default     = false
}

variable "user_assigned_identity_ids" {
  description = "IDs of user-assigned managed identities attached to the SQL server. Required for customer-managed key TDE."
  type        = list(string)
  default     = []
}

variable "databases" {
  description = "Map of SQL databases to create, keyed by database name."
  type = map(object({
    sku_name                    = optional(string, "GP_S_Gen5_2")
    max_size_gb                 = optional(number, 32)
    zone_redundant              = optional(bool, false)
    create_mode                 = optional(string, "Default")
    creation_source_database_id = optional(string, null)
    short_term_retention_days   = optional(number, 7)
    long_term_retention = optional(object({
      weekly_retention  = optional(string, "P1W")
      monthly_retention = optional(string, "P1M")
      yearly_retention  = optional(string, "P1Y")
      week_of_year      = optional(number, 1)
    }), null)
  }))
  default = {}
}

variable "firewall_rules" {
  description = "Map of firewall rules to create, keyed by rule name."
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "virtual_network_rules" {
  description = "Map of virtual network rules to create, keyed by rule name."
  type = map(object({
    subnet_id = string
  }))
  default = {}
}

variable "transparent_data_encryption" {
  description = "Customer-managed key configuration for transparent data encryption. Leave key_vault_key_id null to use service-managed encryption."
  type = object({
    key_vault_key_id      = optional(string, null)
    auto_rotation_enabled = optional(bool, true)
  })
  default = {}
}

variable "auditing" {
  description = "Extended auditing configuration wired to a storage account. Leave blob_storage_endpoint null to disable auditing."
  type = object({
    blob_storage_endpoint                   = optional(string, null)
    storage_account_access_key_is_secondary = optional(bool, false)
    retention_in_days                       = optional(number, 90)
    database_auditing_enabled               = optional(bool, false)
  })
  default = {}
}

variable "auditing_storage_account_access_key" {
  description = "Access key for the storage account used by extended auditing. Never default this to a literal value."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
