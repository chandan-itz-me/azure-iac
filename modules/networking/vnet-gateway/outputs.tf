output "gateway_id" {
  description = "ID of the virtual network gateway."
  value       = azurerm_virtual_network_gateway.this.id
}

output "public_ip_address" {
  description = "Public IP address of the virtual network gateway."
  value       = azurerm_public_ip.this.ip_address
}

output "connection_ids" {
  description = "Map of connection name to its resource ID, for site-to-site connections created by this module."
  value       = { for k, v in azurerm_virtual_network_gateway_connection.this : k => v.id }
}
