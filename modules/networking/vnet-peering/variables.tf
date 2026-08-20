variable "name" {
  description = "Name of the peering created from the local virtual network to the remote virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the local virtual network lives in."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the local virtual network to create the peering from."
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the local virtual network. Required as the remote_virtual_network_id of the reverse peering when create_reverse_peering is true."
  type        = string
}

variable "remote_virtual_network_id" {
  description = "ID of the remote virtual network to peer with."
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Whether resources in the local virtual network can access resources in the remote virtual network."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Whether forwarded traffic from outside the remote virtual network is allowed in."
  type        = bool
  default     = false
}

variable "allow_gateway_transit" {
  description = "Whether the local virtual network's gateway is used by the remote virtual network."
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "Whether the local virtual network uses the remote virtual network's gateway."
  type        = bool
  default     = false
}

variable "create_reverse_peering" {
  description = "Whether to also create the reverse peering, from the remote virtual network back to the local one. Requires peer_resource_group_name and peer_virtual_network_name. Only valid when the remote virtual network is reachable through this module's default azurerm provider configuration; for cross-subscription peering, leave this false and instantiate this module a second time against the remote subscription with providers = { azurerm = azurerm.peer } instead."
  type        = bool
  default     = false
}

variable "peer_resource_group_name" {
  description = "Name of the resource group the remote virtual network lives in. Required when create_reverse_peering is true."
  type        = string
  default     = null
}

variable "peer_virtual_network_name" {
  description = "Name of the remote virtual network. Required when create_reverse_peering is true."
  type        = string
  default     = null
}

variable "reverse_peering_name" {
  description = "Name of the reverse peering. Defaults to \"<name>-reverse\" when not set."
  type        = string
  default     = null
}

variable "reverse_allow_virtual_network_access" {
  description = "Whether resources in the remote virtual network can access resources in the local virtual network, for the reverse peering."
  type        = bool
  default     = true
}

variable "reverse_allow_forwarded_traffic" {
  description = "Whether forwarded traffic from outside the local virtual network is allowed in, for the reverse peering."
  type        = bool
  default     = false
}

variable "reverse_allow_gateway_transit" {
  description = "Whether the remote virtual network's gateway is used by the local virtual network, for the reverse peering."
  type        = bool
  default     = false
}

variable "reverse_use_remote_gateways" {
  description = "Whether the remote virtual network uses the local virtual network's gateway, for the reverse peering."
  type        = bool
  default     = false
}
