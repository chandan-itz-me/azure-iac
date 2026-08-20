variable "name" {
  description = "Name of the virtual machine and prefix applied to associated resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the virtual machine is created in."
  type        = string
}

variable "location" {
  description = "Azure region the virtual machine is deployed to."
  type        = string
}

variable "os_type" {
  description = "Operating system family of the virtual machine, linux or windows."
  type        = string

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either \"linux\" or \"windows\"."
  }
}

variable "size" {
  description = "Azure VM size (SKU), e.g. Standard_D2s_v5."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the virtual machine."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user. Required for linux VMs when generate_admin_password is false."
  type        = string
  default     = null
}

variable "admin_password" {
  description = "Administrator password. Required for windows VMs unless generate_admin_password is true. Ignored for linux VMs."
  type        = string
  default     = null
  sensitive   = true
}

variable "generate_admin_password" {
  description = "Whether to generate a random administrator password instead of using admin_password."
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "ID of the subnet the virtual machine's network interface is attached to."
  type        = string
}

variable "private_ip_address" {
  description = "Static private IP address to assign. Uses dynamic allocation when null."
  type        = string
  default     = null
}

variable "public_ip_enabled" {
  description = "Whether a public IP address is created and associated with the virtual machine."
  type        = bool
  default     = false
}

variable "public_ip_allocation_method" {
  description = "Allocation method for the public IP address, Static or Dynamic. Only used when public_ip_enabled is true."
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "public_ip_allocation_method must be either \"Static\" or \"Dynamic\"."
  }
}

variable "public_ip_sku" {
  description = "SKU of the public IP address. Only used when public_ip_enabled is true."
  type        = string
  default     = "Standard"
}

variable "os_disk" {
  description = "OS disk configuration for the virtual machine."
  type = object({
    caching                = string
    storage_account_type   = optional(string, "Premium_LRS")
    disk_size_gb           = optional(number)
    disk_encryption_set_id = optional(string)
  })
  default = {
    caching = "ReadWrite"
  }
}

variable "source_image_reference" {
  description = "Marketplace image reference (publisher, offer, sku, version). Mutually exclusive with source_image_id."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "source_image_id" {
  description = "ID of a custom image or shared image gallery version. Mutually exclusive with source_image_reference."
  type        = string
  default     = null
}

variable "data_disks" {
  description = "Map of additional managed data disks to create and attach, keyed by a unique disk name."
  type = map(object({
    storage_account_type = optional(string, "Premium_LRS")
    disk_size_gb         = number
    lun                  = number
    caching              = optional(string, "ReadWrite")
  }))
  default = {}
}

variable "boot_diagnostics_enabled" {
  description = "Whether boot diagnostics are enabled for the virtual machine."
  type        = bool
  default     = true
}

variable "boot_diagnostics_storage_account_uri" {
  description = "Blob endpoint of the storage account used for boot diagnostics. Uses a Microsoft-managed storage account when null."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Type of managed identity assigned to the virtual machine."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be one of \"SystemAssigned\", \"UserAssigned\", \"SystemAssigned, UserAssigned\" or \"None\"."
  }
}

variable "identity_ids" {
  description = "List of user assigned identity IDs. Required when identity_type includes UserAssigned."
  type        = list(string)
  default     = []
}

variable "custom_data" {
  description = "Base64-encoded custom data (cloud-init or PowerShell) passed to the virtual machine at provisioning time."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone the virtual machine is pinned to. Uses no zone pinning when null."
  type        = string
  default     = null
}

variable "extensions" {
  description = "Map of VM extensions to install, keyed by a unique extension name."
  type = map(object({
    publisher                  = string
    type                       = string
    type_handler_version       = string
    auto_upgrade_minor_version = optional(bool, true)
    settings                   = optional(string)
    protected_settings         = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
