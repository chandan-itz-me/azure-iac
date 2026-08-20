output "id" {
  description = "ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.id
}

output "endpoint" {
  description = "Endpoint used to connect to the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_key" {
  description = "Primary master key of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "connection_strings" {
  description = "Map of API name to connection string for the Cosmos DB account."
  value = {
    sql     = azurerm_cosmosdb_account.this.primary_sql_connection_string
    mongodb = azurerm_cosmosdb_account.this.primary_mongodb_connection_string
  }
  sensitive = true
}

output "sql_database_ids" {
  description = "Map of SQL database name to resource ID."
  value       = { for k, v in azurerm_cosmosdb_sql_database.this : k => v.id }
}

output "sql_container_ids" {
  description = "Map of \"database/container\" name to resource ID."
  value       = { for k, v in azurerm_cosmosdb_sql_container.this : k => v.id }
}
