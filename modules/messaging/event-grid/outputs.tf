output "topic_id" {
  description = "ID of the Event Grid custom topic, when create_domain is false."
  value       = try(azurerm_eventgrid_topic.this[0].id, null)
}

output "domain_id" {
  description = "ID of the Event Grid domain, when create_domain is true."
  value       = try(azurerm_eventgrid_domain.this[0].id, null)
}

output "topic_endpoint" {
  description = "Endpoint of the Event Grid topic or domain used to publish events."
  value       = try(azurerm_eventgrid_topic.this[0].endpoint, azurerm_eventgrid_domain.this[0].endpoint, null)
}

output "primary_access_key" {
  description = "Primary access key of the Event Grid topic or domain."
  value       = try(azurerm_eventgrid_topic.this[0].primary_access_key, azurerm_eventgrid_domain.this[0].primary_access_key, null)
  sensitive   = true
}

output "event_subscription_ids" {
  description = "Map of event subscription name to its ID."
  value       = { for k, v in azurerm_eventgrid_event_subscription.this : k => v.id }
}
