# -----------------------------------------------------------------------------
# Root composition outputs
# -----------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the created virtual network."
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Subnet IDs created by the networking composition."
  value       = module.subnets.subnet_ids
}

output "storage_account_name" {
  description = "Name of the application storage account."
  value       = module.storage_account.name
}

output "key_vault_uri" {
  description = "URI of the core Key Vault."
  value       = module.key_vault.vault_uri
}

output "function_app_default_hostname" {
  description = "Default hostname of the core Function App."
  value       = module.function_app.default_hostname
}

output "function_app_identity_principal_id" {
  description = "Principal ID of the managed identity created for the Function App."
  value       = module.function_app_identity.principal_ids["function_app"]
}

output "log_analytics_workspace_id" {
  description = "ID of the core Log Analytics workspace."
  value       = module.log_analytics_workspace.workspace_id
}
