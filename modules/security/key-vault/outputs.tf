output "id" {
  description = "ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "vault_uri" {
  description = "URI of the Key Vault, used to reference secrets, keys and certificates."
  value       = azurerm_key_vault.this.vault_uri
}

output "key_ids" {
  description = "Map of key names to their versionless Key Vault Key IDs."
  value       = { for k, v in azurerm_key_vault_key.this : k => v.id }
}

output "key_versions" {
  description = "Map of key names to their current version."
  value       = { for k, v in azurerm_key_vault_key.this : k => v.version }
}
