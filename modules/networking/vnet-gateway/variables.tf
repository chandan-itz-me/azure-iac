variable "name" {
  description = "Name of the virtual network gateway and prefix applied to associated resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the virtual network gateway is created in."
  type        = string
}

variable "location" {
  description = "Azure region the virtual network gateway is deployed to."
  type        = string
}

variable "subnet_id" {
  description = "ID of the GatewaySubnet the gateway's IP configuration is attached to."
  type        = string
}

variable "type" {
  description = "Type of virtual network gateway."
  type        = string
  default     = "Vpn"

  validation {
    condition     = contains(["Vpn", "ExpressRoute"], var.type)
    error_message = "type must be either Vpn or ExpressRoute."
  }
}

variable "vpn_type" {
  description = "Routing type of the VPN gateway."
  type        = string
  default     = "RouteBased"

  validation {
    condition     = contains(["RouteBased", "PolicyBased"], var.vpn_type)
    error_message = "vpn_type must be either RouteBased or PolicyBased."
  }
}

variable "sku" {
  description = "SKU of the virtual network gateway."
  type        = string
  default     = "VpnGw1"

  validation {
    condition = contains([
      "Basic", "VpnGw1", "VpnGw2", "VpnGw3", "VpnGw4", "VpnGw5",
      "VpnGw1AZ", "VpnGw2AZ", "VpnGw3AZ", "VpnGw4AZ", "VpnGw5AZ",
      "Standard", "HighPerformance", "UltraPerformance", "ErGw1AZ", "ErGw2AZ", "ErGw3AZ",
    ], var.sku)
    error_message = "sku must be a valid Vpn or ExpressRoute gateway SKU."
  }
}

variable "generation" {
  description = "Generation of the virtual network gateway."
  type        = string
  default     = "Generation1"

  validation {
    condition     = contains(["Generation1", "Generation2", "None"], var.generation)
    error_message = "generation must be one of Generation1, Generation2, None."
  }
}

variable "active_active" {
  description = "Whether the gateway is deployed in an active-active configuration."
  type        = bool
  default     = false
}

variable "enable_bgp" {
  description = "Whether BGP is enabled on the gateway."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "SKU of the public IP address created for the gateway's IP configuration."
  type        = string
  default     = "Standard"
}

variable "zones" {
  description = "Availability zones the gateway's public IP is pinned to. Only supported with zone-redundant SKUs."
  type        = list(string)
  default     = null
}

variable "vpn_client_configuration" {
  description = "Point-to-site VPN client configuration. Leave null to disable point-to-site."
  type = object({
    address_space        = list(string)
    vpn_client_protocols = optional(list(string), null)
    aad_tenant           = optional(string, null)
    aad_audience         = optional(string, null)
    aad_issuer           = optional(string, null)
    root_certificates = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
    revoked_certificates = optional(list(object({
      name       = string
      thumbprint = string
    })), [])
  })
  default = null
}

variable "create_site_to_site" {
  description = "Whether to create local network gateways and connections for site-to-site VPNs."
  type        = bool
  default     = false
}

variable "local_network_gateways" {
  description = "Map of on-premises local network gateways to create, keyed by a logical name. Only used when create_site_to_site is true."
  type = map(object({
    gateway_address = optional(string, null)
    gateway_fqdn    = optional(string, null)
    address_space   = list(string)
    bgp_settings = optional(object({
      asn                 = number
      bgp_peering_address = string
    }), null)
  }))
  default = {}
}

variable "connections" {
  # Not marked sensitive: Terraform forbids sensitive values in for_each. Pass shared_key from a secret store.
  description = "Map of site-to-site VPN connections to create, keyed by a logical name. Only used when create_site_to_site is true."
  type = map(object({
    local_network_gateway_key = string
    shared_key                = string
    connection_protocol       = optional(string, null)
    enable_bgp                = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
