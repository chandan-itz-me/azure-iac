output "app_id" {
  description = "ID of the web app."
  value       = var.os_type == "linux" ? try(azurerm_linux_web_app.this[0].id, null) : try(azurerm_windows_web_app.this[0].id, null)
}

output "default_hostname" {
  description = "Default hostname of the web app."
  value       = var.os_type == "linux" ? try(azurerm_linux_web_app.this[0].default_hostname, null) : try(azurerm_windows_web_app.this[0].default_hostname, null)
}

output "identity_principal_id" {
  description = "Principal ID of the web app's system-assigned managed identity, if enabled."
  value       = var.os_type == "linux" ? try(azurerm_linux_web_app.this[0].identity[0].principal_id, null) : try(azurerm_windows_web_app.this[0].identity[0].principal_id, null)
}

output "slot_ids" {
  description = "Map of deployment slot IDs, keyed by slot name."
  value = var.os_type == "linux" ? (
    { for k, v in azurerm_linux_web_app_slot.this : k => v.id }
    ) : (
    { for k, v in azurerm_windows_web_app_slot.this : k => v.id }
  )
}

output "plan_id" {
  description = "ID of the App Service Plan used by the web app."
  value       = var.create_service_plan ? azurerm_service_plan.this[0].id : var.service_plan_id
}
