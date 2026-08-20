output "id" {
  description = "ID of the application gateway."
  value       = azurerm_application_gateway.this.id
}

output "public_ip_address" {
  description = "Public IP address associated with the application gateway frontend."
  value       = var.create_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

output "backend_address_pool_ids" {
  description = "Map of backend address pool names to their IDs."
  value       = { for pool in azurerm_application_gateway.this.backend_address_pool : pool.name => pool.id }
}

output "identity_principal_id" {
  description = "Principal ID of the gateway's identity, when a user-assigned identity is attached."
  value       = try(azurerm_application_gateway.this.identity[0].principal_id, null)
}
