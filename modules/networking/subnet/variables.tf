variable "resource_group_name" {
  description = "Name of the resource group the virtual network lives in."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the existing virtual network to create subnets in."
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create, keyed by subnet name."
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    }), null)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    network_security_group_id                     = optional(string, null)
    route_table_id                                = optional(string, null)
  }))

  validation {
    condition = alltrue([
      for s in values(var.subnets) : contains(
        ["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"],
        s.private_endpoint_network_policies
      )
    ])
    error_message = "private_endpoint_network_policies must be one of Disabled, Enabled, NetworkSecurityGroupEnabled, RouteTableEnabled."
  }
}
