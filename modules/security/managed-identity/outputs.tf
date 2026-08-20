output "identity_ids" {
  description = "Map of identity keys to their resource IDs."
  value       = { for k, v in azurerm_user_assigned_identity.this : k => v.id }
}

output "principal_ids" {
  description = "Map of identity keys to their principal (object) IDs."
  value       = { for k, v in azurerm_user_assigned_identity.this : k => v.principal_id }
}

output "client_ids" {
  description = "Map of identity keys to their client (application) IDs."
  value       = { for k, v in azurerm_user_assigned_identity.this : k => v.client_id }
}

output "tenant_id" {
  description = "Azure AD tenant ID shared by all identities created by this module."
  value       = length(azurerm_user_assigned_identity.this) > 0 ? values(azurerm_user_assigned_identity.this)[0].tenant_id : null
}
