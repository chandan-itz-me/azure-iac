output "namespace_id" {
  description = "ID of the Event Hubs namespace."
  value       = azurerm_eventhub_namespace.this.id
}

output "eventhub_ids" {
  description = "Map of event hub name to event hub ID."
  value       = { for k, v in azurerm_eventhub.this : k => v.id }
}

output "consumer_group_ids" {
  description = "Map of consumer group name to consumer group ID."
  value       = { for k, v in azurerm_eventhub_consumer_group.this : k => v.id }
}

output "primary_connection_string" {
  description = "Map of authorization rule name to its primary connection string."
  value       = { for k, v in azurerm_eventhub_authorization_rule.this : k => v.primary_connection_string }
  sensitive   = true
}
