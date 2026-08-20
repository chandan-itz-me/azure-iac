output "app_id" {
  description = "ID of the container app."
  value       = azurerm_container_app.this.id
}

output "fqdn" {
  description = "Fully qualified domain name of the container app's ingress endpoint, if ingress is enabled."
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
}

output "environment_id" {
  description = "ID of the Container Apps environment the app runs in."
  value       = var.create_environment ? azurerm_container_app_environment.this[0].id : var.container_app_environment_id
}

output "identity_principal_id" {
  description = "Principal ID of the container app's system-assigned managed identity, if enabled."
  value       = try(azurerm_container_app.this.identity[0].principal_id, null)
}
