output "id" {
  description = "ARM resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "Workspace (customer) ID GUID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "primary_shared_key" {
  description = "Primary shared key used to connect agents to the workspace."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "solution_ids" {
  description = "Map of solution name to its resource ID."
  value       = { for k, v in azurerm_log_analytics_solution.this : k => v.id }
}
