output "secret_ids" {
  description = "Map of secret names to their versionless Key Vault Secret IDs."
  value       = { for k, v in azurerm_key_vault_secret.this : k => v.id }
  sensitive   = true
}

output "versions" {
  description = "Map of secret names to their current version."
  value       = { for k, v in azurerm_key_vault_secret.this : k => v.version }
  sensitive   = true
}
