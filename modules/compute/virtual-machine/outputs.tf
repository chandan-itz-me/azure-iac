output "vm_id" {
  description = "ID of the virtual machine."
  value       = var.os_type == "linux" ? try(azurerm_linux_virtual_machine.this[0].id, null) : try(azurerm_windows_virtual_machine.this[0].id, null)
}

output "private_ip_address" {
  description = "Private IP address of the virtual machine's network interface."
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address associated with the virtual machine, if any."
  value       = try(azurerm_public_ip.this[0].ip_address, null)
}

output "identity_principal_id" {
  description = "Principal ID of the virtual machine's system-assigned managed identity, if enabled."
  value       = var.os_type == "linux" ? try(azurerm_linux_virtual_machine.this[0].identity[0].principal_id, null) : try(azurerm_windows_virtual_machine.this[0].identity[0].principal_id, null)
}

output "network_interface_id" {
  description = "ID of the virtual machine's network interface."
  value       = azurerm_network_interface.this.id
}

output "data_disk_ids" {
  description = "Map of additional data disk IDs, keyed by disk name."
  value       = { for k, v in azurerm_managed_disk.data : k => v.id }
}
