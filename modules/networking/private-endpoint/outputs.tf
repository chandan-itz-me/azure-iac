output "private_endpoint_ids" {
  description = "Map of logical endpoint name to its private endpoint resource ID."
  value       = { for k, v in azurerm_private_endpoint.this : k => v.id }
}

output "private_ip_addresses" {
  description = "Map of logical endpoint name to its private IP address."
  value       = { for k, v in azurerm_private_endpoint.this : k => try(v.private_service_connection[0].private_ip_address, null) }
}

output "network_interface_ids" {
  description = "Map of logical endpoint name to its network interface ID."
  value       = { for k, v in azurerm_private_endpoint.this : k => try(v.network_interface[0].id, null) }
}
