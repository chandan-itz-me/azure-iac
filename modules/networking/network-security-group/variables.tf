variable "name" {
  description = "Name of the network security group and prefix applied to associated resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the network security group is created in."
  type        = string
}

variable "location" {
  description = "Azure region the network security group is deployed to."
  type        = string
}

variable "security_rules" {
  description = "Map of security rules to create on the network security group, keyed by rule name. No inbound access is allowed by default; every rule must be explicit."
  type = map(object({
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    description                                = optional(string, null)
    source_port_range                          = optional(string, null)
    source_port_ranges                         = optional(list(string), null)
    destination_port_range                     = optional(string, null)
    destination_port_ranges                    = optional(list(string), null)
    source_address_prefix                      = optional(string, null)
    source_address_prefixes                    = optional(list(string), null)
    destination_address_prefix                 = optional(string, null)
    destination_address_prefixes               = optional(list(string), null)
    source_application_security_group_ids      = optional(list(string), null)
    destination_application_security_group_ids = optional(list(string), null)
  }))
  default = {}

  validation {
    condition     = alltrue([for r in values(var.security_rules) : contains(["Inbound", "Outbound"], r.direction)])
    error_message = "direction must be either Inbound or Outbound."
  }

  validation {
    condition     = alltrue([for r in values(var.security_rules) : contains(["Allow", "Deny"], r.access)])
    error_message = "access must be either Allow or Deny."
  }

  validation {
    condition     = alltrue([for r in values(var.security_rules) : contains(["Tcp", "Udp", "Icmp", "Esp", "Ah", "*"], r.protocol)])
    error_message = "protocol must be one of Tcp, Udp, Icmp, Esp, Ah, *."
  }
}

variable "subnet_ids" {
  description = "IDs of existing subnets to associate this network security group with."
  type        = list(string)
  default     = []
}

variable "network_interface_ids" {
  description = "IDs of existing network interfaces to associate this network security group with."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
