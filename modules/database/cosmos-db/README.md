# database/cosmos-db

Creates a Cosmos DB account with public network access disabled by default, a
configurable consistency policy, geo-replicated locations and an optional virtual
network filter. Supports the SQL (Core), MongoDB, Cassandra, Gremlin and Table APIs
via the `api` variable, and can provision SQL API databases/containers directly.

For private connectivity, compose this module with the `security/private-endpoint`
module targeting the account's `Sql`, `MongoDB`, `Cassandra`, `Gremlin` or `Table`
sub-resource, matching the selected API.

## Usage

```hcl
module "cosmos_db" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/database/cosmos-db?ref=v1.0.0"

  name                = "platform-cosmos"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  geo_locations = {
    (azurerm_resource_group.platform.location) = { failover_priority = 0 }
  }

  sql_databases = {
    catalog = {
      throughput = 400
      containers = {
        products = {
          partition_key_path = "/id"
        }
      }
    }
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
