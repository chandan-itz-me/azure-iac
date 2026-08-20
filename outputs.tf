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

output "managed_identity_ids" {
  description = "Flattened map of reusable user-assigned managed identity resource IDs, keyed as module-key.identity-key."
  value       = local.managed_identity_ids
}

output "managed_identity_principal_ids" {
  description = "Flattened map of reusable user-assigned managed identity principal IDs, keyed as module-key.identity-key."
  value = merge([
    for module_key, identity_module in module.managed_identities : {
      for identity_key, principal_id in identity_module.principal_ids :
      "${module_key}.${identity_key}" => principal_id
    }
  ]...)
}
