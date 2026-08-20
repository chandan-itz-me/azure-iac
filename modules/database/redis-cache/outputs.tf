output "id" {
  description = "ID of the Redis cache."
  value       = azurerm_redis_cache.this.id
}

output "hostname" {
  description = "Hostname of the Redis cache."
  value       = azurerm_redis_cache.this.hostname
}

output "ssl_port" {
  description = "SSL port of the Redis cache."
  value       = azurerm_redis_cache.this.ssl_port
}

output "primary_access_key" {
  description = "Primary access key of the Redis cache."
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string of the Redis cache."
  value       = azurerm_redis_cache.this.primary_connection_string
  sensitive   = true
}

output "linked_server_ids" {
  description = "Map of linked server name to resource ID."
  value       = { for k, v in azurerm_redis_linked_server.this : k => v.id }
}
