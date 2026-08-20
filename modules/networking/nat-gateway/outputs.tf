output "nat_gateway_id" {
  description = "ID of the NAT gateway."
  value       = azurerm_nat_gateway.this.id
}

output "public_ip_ids" {
  description = "Map of public IP name to its resource ID, for public IPs created by this module."
  value       = { for k, v in azurerm_public_ip.this : k => v.id }
}

output "public_ip_addresses" {
  description = "Map of public IP name to its allocated IP address, for public IPs created by this module."
  value       = { for k, v in azurerm_public_ip.this : k => v.ip_address }
}
