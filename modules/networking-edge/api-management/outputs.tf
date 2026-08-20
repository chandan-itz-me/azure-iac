output "id" {
  description = "ID of the API Management instance."
  value       = azurerm_api_management.this.id
}

output "gateway_url" {
  description = "Gateway URL of the API Management instance."
  value       = azurerm_api_management.this.gateway_url
}

output "identity_principal_id" {
  description = "Principal ID of the API Management instance's managed identity."
  value       = try(azurerm_api_management.this.identity[0].principal_id, null)
}

output "api_ids" {
  description = "Map of API names to their IDs."
  value       = { for k, v in azurerm_api_management_api.this : k => v.id }
}
