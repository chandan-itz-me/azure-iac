output "disk_ids" {
  description = "Map of disk name to managed disk resource ID."
  value       = { for k, v in azurerm_managed_disk.this : k => v.id }
}

output "disk_encryption_set_id" {
  description = "ID of the disk encryption set created by this module, if enabled."
  value       = try(azurerm_disk_encryption_set.this[0].id, null)
}

output "disk_encryption_set_identity_principal_id" {
  description = "Principal ID of the disk encryption set's managed identity, if enabled."
  value       = try(azurerm_disk_encryption_set.this[0].identity[0].principal_id, null)
}
