# database/redis-cache

Creates an Azure Cache for Redis instance with public network access disabled by
default, TLS 1.2 minimum and the non-SSL port disabled. Supports RDB/AOF backups,
maintenance patch schedules, firewall rules and geo-replicated linked servers on the
Premium SKU.

## Usage

```hcl
module "redis" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/database/redis-cache?ref=v1.0.0"

  name                = "platform-cache"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  capacity = 1
  family   = "P"
  sku_name = "Premium"

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
| [azurerm_redis_cache.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_redis_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_firewall_rule) | resource |
| [azurerm_redis_linked_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_linked_server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the Redis cache is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Redis cache. Must be globally unique. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Redis cache is created in. | `string` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Size of the Redis cache. Valid range depends on family/sku\_name (0-6 for C, 1-5 for P). | `number` | `1` | no |
| <a name="input_family"></a> [family](#input\_family) | SKU family of the Redis cache. | `string` | `"C"` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Map of firewall rules to create, keyed by rule name. | <pre>map(object({<br/>    start_ip = string<br/>    end_ip   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_servers"></a> [linked\_servers](#input\_linked\_servers) | Map of linked Redis caches for geo-replication, keyed by linked server name. Only supported by the Premium SKU. | <pre>map(object({<br/>    linked_redis_cache_id       = string<br/>    linked_redis_cache_location = string<br/>    server_role                 = optional(string, "Secondary")<br/>  }))</pre> | `{}` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | Minimum TLS version accepted by the Redis cache. | `string` | `"1.2"` | no |
| <a name="input_patch_schedules"></a> [patch\_schedules](#input\_patch\_schedules) | List of maintenance patch schedules for the Redis cache. Only supported by the Premium SKU. | <pre>list(object({<br/>    day_of_week        = string<br/>    start_hour_utc     = optional(number, 0)<br/>    maintenance_window = optional(string, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the Redis cache is enabled. | `bool` | `false` | no |
| <a name="input_redis_configuration"></a> [redis\_configuration](#input\_redis\_configuration) | Redis server configuration, including optional RDB/AOF backup settings. Storage connection strings are sensitive and only used by the Premium SKU. | <pre>object({<br/>    maxmemory_policy                = optional(string, "volatile-lru")<br/>    enable_authentication           = optional(bool, true)<br/>    rdb_backup_enabled              = optional(bool, false)<br/>    rdb_backup_frequency            = optional(number, 60)<br/>    rdb_backup_max_snapshot_count   = optional(number, 1)<br/>    rdb_storage_connection_string   = optional(string, null)<br/>    aof_backup_enabled              = optional(bool, false)<br/>    aof_storage_connection_string_0 = optional(string, null)<br/>    aof_storage_connection_string_1 = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU name of the Redis cache. | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Availability zones the Redis cache is deployed across. Only supported by the Premium SKU. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Hostname of the Redis cache. |
| <a name="output_id"></a> [id](#output\_id) | ID of the Redis cache. |
| <a name="output_linked_server_ids"></a> [linked\_server\_ids](#output\_linked\_server\_ids) | Map of linked server name to resource ID. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | Primary access key of the Redis cache. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | Primary connection string of the Redis cache. |
| <a name="output_ssl_port"></a> [ssl\_port](#output\_ssl\_port) | SSL port of the Redis cache. |
<!-- END_TF_DOCS -->
