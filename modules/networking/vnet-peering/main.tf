resource "azurerm_virtual_network_peering" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.virtual_network_name
  remote_virtual_network_id    = var.remote_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "reverse" {
  count = var.create_reverse_peering ? 1 : 0

  name                         = coalesce(var.reverse_peering_name, "${var.name}-reverse")
  resource_group_name          = var.peer_resource_group_name
  virtual_network_name         = var.peer_virtual_network_name
  remote_virtual_network_id    = var.virtual_network_id
  allow_virtual_network_access = var.reverse_allow_virtual_network_access
  allow_forwarded_traffic      = var.reverse_allow_forwarded_traffic
  allow_gateway_transit        = var.reverse_allow_gateway_transit
  use_remote_gateways          = var.reverse_use_remote_gateways

  lifecycle {
    precondition {
      condition     = var.peer_resource_group_name != null && var.peer_virtual_network_name != null
      error_message = "peer_resource_group_name and peer_virtual_network_name are required when create_reverse_peering is true."
    }
  }
}
