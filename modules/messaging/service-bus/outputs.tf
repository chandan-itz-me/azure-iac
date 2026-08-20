output "namespace_id" {
  description = "ID of the Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.id
}

output "queue_ids" {
  description = "Map of queue name to queue ID."
  value       = { for k, v in azurerm_servicebus_queue.this : k => v.id }
}

output "topic_ids" {
  description = "Map of topic name to topic ID."
  value       = { for k, v in azurerm_servicebus_topic.this : k => v.id }
}

output "subscription_ids" {
  description = "Map of \"topic.subscription\" to subscription ID."
  value       = { for k, v in azurerm_servicebus_subscription.this : k => v.id }
}

output "primary_connection_string" {
  description = "Map of authorization rule name to its primary connection string."
  value       = { for k, v in azurerm_servicebus_namespace_authorization_rule.this : k => v.primary_connection_string }
  sensitive   = true
}
