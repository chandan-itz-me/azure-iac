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
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.90.0, < 4.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_cosmosdb_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_sql_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_geo_locations"></a> [geo\_locations](#input\_geo\_locations) | Map of geo-replicated locations, keyed by Azure region name. | <pre>map(object({<br/>    failover_priority = number<br/>    zone_redundant    = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the Cosmos DB account's primary write location is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Cosmos DB account. Must be globally unique, lowercase alphanumeric and hyphens. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Cosmos DB account is created in. | `string` | n/a | yes |
| <a name="input_api"></a> [api](#input\_api) | Cosmos DB API surface to expose. Determines the account kind and enabled capabilities. | `string` | `"Sql"` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Whether automatic failover is enabled for the Cosmos DB account. | `bool` | `true` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | Backup configuration for the Cosmos DB account. Continuous backup ignores interval/retention/storage\_redundancy; periodic backup ignores tier. | <pre>object({<br/>    type                = optional(string, "Periodic")<br/>    interval_in_minutes = optional(number, 240)<br/>    retention_in_hours  = optional(number, 8)<br/>    storage_redundancy  = optional(string, "Local")<br/>    tier                = optional(string, "Continuous7Days")<br/>  })</pre> | `{}` | no |
| <a name="input_consistency_policy"></a> [consistency\_policy](#input\_consistency\_policy) | Default consistency policy for the Cosmos DB account. | <pre>object({<br/>    consistency_level       = optional(string, "Session")<br/>    max_interval_in_seconds = optional(number, 5)<br/>    max_staleness_prefix    = optional(number, 100)<br/>  })</pre> | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Optional managed identity configuration for the Cosmos DB account. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_is_virtual_network_filter_enabled"></a> [is\_virtual\_network\_filter\_enabled](#input\_is\_virtual\_network\_filter\_enabled) | Whether virtual network filtering is enabled for the Cosmos DB account. | `bool` | `false` | no |
| <a name="input_multiple_write_locations_enabled"></a> [multiple\_write\_locations\_enabled](#input\_multiple\_write\_locations\_enabled) | Whether multiple write locations (multi-region writes) are enabled. | `bool` | `false` | no |
| <a name="input_offer_type"></a> [offer\_type](#input\_offer\_type) | Offer type for the Cosmos DB account. | `string` | `"Standard"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the Cosmos DB account is enabled. | `bool` | `false` | no |
| <a name="input_sql_databases"></a> [sql\_databases](#input\_sql\_databases) | Map of SQL API databases and their containers, keyed by database name. | <pre>map(object({<br/>    throughput               = optional(number, null)<br/>    autoscale_max_throughput = optional(number, null)<br/>    containers = optional(map(object({<br/>      partition_key_path       = string<br/>      throughput               = optional(number, null)<br/>      autoscale_max_throughput = optional(number, null)<br/>      indexing_policy = optional(object({<br/>        indexing_mode  = optional(string, "consistent")<br/>        included_paths = optional(list(string), ["/*"])<br/>        excluded_paths = optional(list(string), [])<br/>      }), null)<br/>      unique_keys = optional(list(list(string)), [])<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_rules"></a> [virtual\_network\_rules](#input\_virtual\_network\_rules) | List of subnet IDs allowed to access the Cosmos DB account when virtual network filtering is enabled. | <pre>list(object({<br/>    subnet_id                            = string<br/>    ignore_missing_vnet_service_endpoint = optional(bool, false)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_connection_strings"></a> [connection\_strings](#output\_connection\_strings) | Map of API name to connection string for the Cosmos DB account. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint used to connect to the Cosmos DB account. |
| <a name="output_id"></a> [id](#output\_id) | ID of the Cosmos DB account. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the account managed identity, when identity is enabled. |
| <a name="output_primary_key"></a> [primary\_key](#output\_primary\_key) | Primary master key of the Cosmos DB account. |
| <a name="output_sql_container_ids"></a> [sql\_container\_ids](#output\_sql\_container\_ids) | Map of "database/container" name to resource ID. |
| <a name="output_sql_database_ids"></a> [sql\_database\_ids](#output\_sql\_database\_ids) | Map of SQL database name to resource ID. |
<!-- END_TF_DOCS -->
