output "id" {
  description = "ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob service endpoint of the storage account."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "Primary access key of the storage account."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string of the storage account."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "container_ids" {
  description = "Map of container name to container resource ID."
  value       = { for k, v in azurerm_storage_container.this : k => v.id }
}

output "share_ids" {
  description = "Map of file share name to file share resource ID."
  value       = { for k, v in azurerm_storage_share.this : k => v.id }
}

output "identity_principal_id" {
  description = "Principal ID of the storage account's system-assigned managed identity."
  value       = try(azurerm_storage_account.this.identity[0].principal_id, null)
}
