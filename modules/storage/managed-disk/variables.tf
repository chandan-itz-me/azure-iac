variable "resource_group_name" {
  description = "Name of the resource group the managed disks are created in."
  type        = string
}

variable "location" {
  description = "Azure region the managed disks are deployed to."
  type        = string
}

variable "name" {
  description = "Name prefix applied to resources created by this module when a single logical name is required."
  type        = string
  default     = "managed-disk"
}

variable "disks" {
  description = "Map of managed disks to create, keyed by disk name."
  type = map(object({
    storage_account_type   = optional(string, "Premium_LRS")
    disk_size_gb           = optional(number, null)
    create_option          = optional(string, "Empty")
    source_resource_id     = optional(string, null)
    source_uri             = optional(string, null)
    os_type                = optional(string, null)
    hyper_v_generation     = optional(string, null)
    disk_encryption_set_id = optional(string, null)
    network_access_policy  = optional(string, "DenyAll")
    disk_access_id         = optional(string, null)
    zone                   = optional(string, null)
  }))
  default = {}
}

variable "disk_encryption_set" {
  description = "Optional disk encryption set created by this module. When enabled, disks may reference its ID via disk_encryption_set_id."
  type = object({
    enabled                    = bool
    key_vault_key_id           = string
    identity_type              = optional(string, "SystemAssigned")
    user_assigned_identity_ids = optional(list(string), [])
  })
  default = {
    enabled                    = false
    key_vault_key_id           = null
    identity_type              = "SystemAssigned"
    user_assigned_identity_ids = []
  }
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
