output "function_app_id" {
  description = "ID of the function app."
  value       = var.os_type == "linux" ? try(azurerm_linux_function_app.this[0].id, null) : try(azurerm_windows_function_app.this[0].id, null)
}

output "default_hostname" {
  description = "Default hostname of the function app."
  value       = var.os_type == "linux" ? try(azurerm_linux_function_app.this[0].default_hostname, null) : try(azurerm_windows_function_app.this[0].default_hostname, null)
}

output "identity_principal_id" {
  description = "Principal ID of the function app's system-assigned managed identity, if enabled."
  value       = var.os_type == "linux" ? try(azurerm_linux_function_app.this[0].identity[0].principal_id, null) : try(azurerm_windows_function_app.this[0].identity[0].principal_id, null)
}

output "outbound_ip_addresses" {
  description = "Comma-separated list of outbound IP addresses used by the function app."
  value       = var.os_type == "linux" ? try(azurerm_linux_function_app.this[0].outbound_ip_addresses, null) : try(azurerm_windows_function_app.this[0].outbound_ip_addresses, null)
}
