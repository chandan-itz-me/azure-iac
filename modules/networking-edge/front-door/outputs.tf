output "profile_id" {
  description = "ID of the Front Door profile."
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_hostname" {
  description = "Default hostname of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "route_ids" {
  description = "Map of route names to their IDs."
  value       = { for k, v in azurerm_cdn_frontdoor_route.this : k => v.id }
}

output "custom_domain_ids" {
  description = "Map of custom domain names to their IDs."
  value       = { for k, v in azurerm_cdn_frontdoor_custom_domain.this : k => v.id }
}
