output "server_id" {
  description = "ID of the SQL server."
  value       = azurerm_mssql_server.this.id
}

output "fully_qualified_domain_name" {
  description = "Fully qualified domain name of the SQL server."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_ids" {
  description = "Map of database name to resource ID."
  value       = { for k, v in azurerm_mssql_database.this : k => v.id }
}

output "identity_principal_id" {
  description = "Principal ID of the SQL server's system-assigned managed identity."
  value       = try(azurerm_mssql_server.this.identity[0].principal_id, null)
}
