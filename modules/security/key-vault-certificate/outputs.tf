output "certificate_ids" {
  description = "Map of certificate names to their versionless Key Vault Certificate IDs."
  value       = { for k, v in azurerm_key_vault_certificate.this : k => v.id }
}

output "secret_ids" {
  description = "Map of certificate names to the versionless ID of the backing Key Vault secret."
  value       = { for k, v in azurerm_key_vault_certificate.this : k => v.secret_id }
  sensitive   = true
}

output "thumbprints" {
  description = "Map of certificate names to their SHA-1 thumbprints."
  value       = { for k, v in azurerm_key_vault_certificate.this : k => v.thumbprint }
}

output "versions" {
  description = "Map of certificate names to their current version."
  value       = { for k, v in azurerm_key_vault_certificate.this : k => v.version }
}
