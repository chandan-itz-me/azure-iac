output "resource_group_name" {
  description = "Name of the resource group hosting the state backend."
  value       = local.resource_group_name
}

output "storage_account_name" {
  description = "Name of the storage account hosting Terraform state."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "ID of the storage account hosting Terraform state."
  value       = azurerm_storage_account.this.id
}

output "container_name" {
  description = "Name of the blob container storing Terraform state files."
  value       = azurerm_storage_container.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob service endpoint of the storage account."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "role_assignment_ids" {
  description = "Map of principal ID to the ID of its Storage Blob Data Contributor role assignment."
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}

output "backend_config" {
  description = "Values for the azurerm backend block or a -backend-config file. The key is a placeholder; set it per state file (e.g. \"<environment>.tfstate\")."
  value = {
    resource_group_name  = local.resource_group_name
    storage_account_name = azurerm_storage_account.this.name
    container_name       = azurerm_storage_container.this.name
    key                  = "terraform.tfstate"
  }
}
