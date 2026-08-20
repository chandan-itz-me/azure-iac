variable "name" {
  description = "Name of the virtual network and prefix applied to associated resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the virtual network is created in."
  type        = string
}

variable "location" {
  description = "Azure region the virtual network is deployed to."
  type        = string
}

variable "address_space" {
  description = "List of IPv4/IPv6 address ranges for the virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "Custom DNS server IP addresses used by the virtual network. Uses Azure-provided DNS when empty."
  type        = list(string)
  default     = []
}

variable "bgp_community" {
  description = "BGP community attached to the virtual network, in the format 12076:xxxxx."
  type        = string
  default     = null
}

variable "ddos_protection_plan_id" {
  description = "ID of an existing DDoS protection plan to associate with the virtual network."
  type        = string
  default     = null
}

variable "enable_ddos_protection" {
  description = "Whether the DDoS protection plan association is enabled. Only used when ddos_protection_plan_id is set."
  type        = bool
  default     = false
}

variable "flow_timeout_in_minutes" {
  description = "UDP idle timeout in minutes applied to the virtual network, between 4 and 30."
  type        = number
  default     = null

  validation {
    condition     = var.flow_timeout_in_minutes == null || (var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30)
    error_message = "flow_timeout_in_minutes must be between 4 and 30."
  }
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
