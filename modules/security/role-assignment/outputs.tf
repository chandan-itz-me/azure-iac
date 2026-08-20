output "assignment_ids" {
  description = "Map of assignment keys to their role assignment IDs."
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}

output "custom_role_definition_ids" {
  description = "Map of custom role keys to their role definition resource IDs."
  value       = { for k, v in azurerm_role_definition.this : k => v.role_definition_resource_id }
}
