output "peering_id" {
  description = "ID of the peering from the local virtual network to the remote virtual network."
  value       = azurerm_virtual_network_peering.this.id
}

output "peering_state" {
  # azurerm no longer exports a peering_state attribute; kept as null for interface stability.
  description = "Reserved for the peering's connectivity state. Always null: the azurerm provider no longer exports this attribute, query the peering with the azurerm_virtual_network_peering data source if needed."
  value       = null
}

output "reverse_peering_id" {
  description = "ID of the reverse peering, when create_reverse_peering is true."
  value       = try(azurerm_virtual_network_peering.reverse[0].id, null)
}
