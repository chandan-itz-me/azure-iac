variable "name" {
  description = "Name of the virtual machine scale set."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the scale set is created in."
  type        = string
}

variable "location" {
  description = "Azure region the scale set is deployed to."
  type        = string
}

variable "os_type" {
  description = "Operating system family of the scale set instances, linux or windows."
  type        = string

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either \"linux\" or \"windows\"."
  }
}

variable "orchestration_mode" {
  description = "Reserved for documentation only. This module implements Uniform orchestration (azurerm_linux/windows_virtual_machine_scale_set). Flexible orchestration requires the separate azurerm_orchestrated_virtual_machine_scale_set resource and is not covered by this module."
  type        = string
  default     = "Uniform"

  validation {
    condition     = var.orchestration_mode == "Uniform"
    error_message = "orchestration_mode must be \"Uniform\"; Flexible orchestration is not implemented by this module."
  }
}

variable "sku" {
  description = "Azure VM size (SKU) used for scale set instances, e.g. Standard_D2s_v5."
  type        = string
}

variable "instances" {
  description = "Base number of instances running in the scale set."
  type        = number
  default     = 2
}

variable "upgrade_mode" {
  description = "Upgrade mode for the scale set, Manual, Automatic or Rolling."
  type        = string
  default     = "Manual"

  validation {
    condition     = contains(["Manual", "Automatic", "Rolling"], var.upgrade_mode)
    error_message = "upgrade_mode must be one of \"Manual\", \"Automatic\" or \"Rolling\"."
  }
}

variable "rolling_upgrade_policy" {
  description = "Rolling upgrade policy. Only used when upgrade_mode is \"Rolling\"."
  type = object({
    max_batch_instance_percent              = number
    max_unhealthy_instance_percent          = number
    max_unhealthy_upgraded_instance_percent = number
    pause_time_between_batches              = string
  })
  default = null
}

variable "health_probe_id" {
  description = "ID of a load balancer health probe used to monitor instance health during rolling upgrades."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Administrator username for scale set instances."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user. Required for linux scale sets when generate_admin_password is false."
  type        = string
  default     = null
}

variable "admin_password" {
  description = "Administrator password. Required for windows scale sets unless generate_admin_password is true. Ignored for linux scale sets."
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
  description = "ID of the subnet the scale set's network interfaces are attached to."
  type        = string
}

variable "lb_backend_address_pool_ids" {
  description = "List of load balancer backend address pool IDs to associate with the scale set."
  type        = list(string)
  default     = []
}

variable "application_gateway_backend_address_pool_ids" {
  description = "List of application gateway backend address pool IDs to associate with the scale set."
  type        = list(string)
  default     = []
}

variable "os_disk" {
  description = "OS disk configuration for scale set instances."
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

variable "identity_type" {
  description = "Type of managed identity assigned to scale set instances."
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

variable "zones" {
  description = "List of availability zones the scale set is spread across."
  type        = list(string)
  default     = []
}

variable "overprovision" {
  description = "Whether the scale set overprovisions instances to improve deployment success rate. Not supported in Flexible orchestration mode."
  type        = bool
  default     = true
}

variable "single_placement_group" {
  description = "Whether the scale set is limited to a single placement group of up to 100 instances."
  type        = bool
  default     = true
}

variable "enable_autoscale" {
  description = "Whether an autoscale setting is created for the scale set."
  type        = bool
  default     = false
}

variable "autoscale_min_instances" {
  description = "Minimum instance count for the autoscale setting. Only used when enable_autoscale is true."
  type        = number
  default     = 1
}

variable "autoscale_max_instances" {
  description = "Maximum instance count for the autoscale setting. Only used when enable_autoscale is true."
  type        = number
  default     = 5
}

variable "autoscale_default_instances" {
  description = "Default instance count for the autoscale setting. Only used when enable_autoscale is true."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
