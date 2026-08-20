output "subnet_ids" {
  description = "Map of subnet name to subnet ID."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet name to its address prefixes."
  value       = { for k, v in azurerm_subnet.this : k => v.address_prefixes }
}
