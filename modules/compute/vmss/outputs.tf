output "vmss_id" {
  description = "ID of the virtual machine scale set."
  value       = var.os_type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.this[0].id, null) : try(azurerm_windows_virtual_machine_scale_set.this[0].id, null)
}

output "identity_principal_id" {
  description = "Principal ID of the scale set's system-assigned managed identity, if enabled."
  value       = var.os_type == "linux" ? try(azurerm_linux_virtual_machine_scale_set.this[0].identity[0].principal_id, null) : try(azurerm_windows_virtual_machine_scale_set.this[0].identity[0].principal_id, null)
}

output "instances" {
  description = "Base number of instances configured on the scale set."
  value       = var.instances
}
