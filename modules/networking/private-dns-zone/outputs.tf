output "zone_id" {
  description = "ID of the private DNS zone."
  value       = azurerm_private_dns_zone.this.id
}

output "zone_name" {
  description = "Name of the private DNS zone."
  value       = azurerm_private_dns_zone.this.name
}

output "record_ids" {
  description = "Map of record name to its resource ID, across all record types."
  value = merge(
    { for k, v in azurerm_private_dns_a_record.this : k => v.id },
    { for k, v in azurerm_private_dns_aaaa_record.this : k => v.id },
    { for k, v in azurerm_private_dns_cname_record.this : k => v.id },
    { for k, v in azurerm_private_dns_ptr_record.this : k => v.id },
    { for k, v in azurerm_private_dns_mx_record.this : k => v.id },
    { for k, v in azurerm_private_dns_srv_record.this : k => v.id },
    { for k, v in azurerm_private_dns_txt_record.this : k => v.id },
  )
}

output "vnet_link_ids" {
  description = "Map of virtual network link name to its resource ID."
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.this : k => v.id }
}
