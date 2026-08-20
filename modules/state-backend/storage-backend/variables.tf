variable "create_resource_group" {
  description = "Whether to create the resource group. Set to false to use an existing resource group named by resource_group_name."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Name of the resource group to create, or the name of an existing resource group when create_resource_group is false."
  type        = string
}

variable "location" {
  description = "Azure region the state backend resources are deployed to."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique name of the storage account hosting Terraform state (lowercase letters and numbers only, 3-24 characters)."
  type        = string
}

variable "account_replication_type" {
  description = "Replication strategy for the storage account. Defaults to GRS for cross-region durability of state files."
  type        = string
  default     = "GRS"

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
    condition     = contains(["TLS1_2", "TLS1_3"], var.min_tls_version)
    error_message = "min_tls_version must be TLS1_2 or TLS1_3."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the storage account is enabled. Disabled by default; CI runners will need an allowed_ip_rules entry or a private endpoint to reach the backend."
  type        = bool
  default     = false
}

variable "allowed_ip_rules" {
  description = "Public IP address ranges allowed to reach the storage account when public network access is restricted (e.g. CI runner egress IPs)."
  type        = list(string)
  default     = []
}

variable "container_name" {
  description = "Name of the blob container that stores Terraform state files."
  type        = string
  default     = "tfstate"
}

variable "delete_retention_days" {
  description = "Number of days deleted blobs are retained, enabling recovery of accidentally deleted or overwritten state files."
  type        = number
  default     = 30

  validation {
    condition     = var.delete_retention_days >= 1 && var.delete_retention_days <= 365
    error_message = "delete_retention_days must be between 1 and 365."
  }
}

variable "enable_customer_managed_key" {
  description = "Whether the storage account is encrypted with a customer-managed key from an existing Key Vault, instead of Microsoft-managed keys."
  type        = bool
  default     = false
}

variable "customer_managed_key" {
  description = "Customer-managed key configuration. Required when enable_customer_managed_key is true. The storage account is granted a system-assigned identity to access the key."
  type = object({
    key_vault_id              = string
    key_name                  = string
    key_version               = optional(string, null)
    user_assigned_identity_id = optional(string, null)
  })
  default = null
}

variable "create_role_assignments" {
  description = "Whether to grant Storage Blob Data Contributor on the storage account to the principals in runner_principal_ids."
  type        = bool
  default     = false
}

variable "runner_principal_ids" {
  description = "Object IDs of the service principals or managed identities (e.g. Terraform CI runners) granted Storage Blob Data Contributor when create_role_assignments is true."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
