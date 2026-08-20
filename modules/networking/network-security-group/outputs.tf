output "nsg_id" {
  description = "ID of the network security group."
  value       = azurerm_network_security_group.this.id
}

output "nsg_name" {
  description = "Name of the network security group."
  value       = azurerm_network_security_group.this.name
}

output "rule_ids" {
  description = "Map of security rule name to its resource ID."
  value       = { for k, v in azurerm_network_security_rule.this : k => v.id }
}
