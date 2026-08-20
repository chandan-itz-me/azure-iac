variable "name" {
  description = "Name of the NAT gateway and prefix applied to associated resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the NAT gateway is created in."
  type        = string
}

variable "location" {
  description = "Azure region the NAT gateway is deployed to."
  type        = string
}

variable "sku_name" {
  description = "SKU of the NAT gateway."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard"], var.sku_name)
    error_message = "sku_name must be Standard."
  }
}

variable "idle_timeout_in_minutes" {
  description = "Idle timeout in minutes for the NAT gateway, between 4 and 120."
  type        = number
  default     = 4

  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 120
    error_message = "idle_timeout_in_minutes must be between 4 and 120."
  }
}

variable "zones" {
  description = "Availability zones the NAT gateway and any public IPs created by this module are pinned to."
  type        = list(string)
  default     = null
}

variable "public_ip_names" {
  description = "Names of new public IP addresses to create and associate with the NAT gateway."
  type        = set(string)
  default     = []
}

variable "existing_public_ip_ids" {
  description = "IDs of existing public IP addresses to associate with the NAT gateway instead of creating new ones."
  type        = set(string)
  default     = []
}

variable "public_ip_prefix_id" {
  description = "ID of an existing public IP prefix to associate with the NAT gateway."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Map of subnets to associate with the NAT gateway, keyed by a logical name."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
