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
<!-- END_TF_DOCS -->
