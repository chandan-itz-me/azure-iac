# networking/private-endpoint

Creates one or more private endpoints attached to a single subnet from a map of
endpoint definitions, each targeting a private link resource by ID and subresource
name. Supports manual connection approval and wiring an optional private DNS zone
group per endpoint.

## Usage

```hcl
module "private_endpoints" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/private-endpoint?ref=v1.0.0"

  name                = "platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  subnet_id           = module.subnets.subnet_ids["data"]

  endpoints = {
    storage = {
      private_connection_resource_id = azurerm_storage_account.this.id
      subresource_names              = ["blob"]
      private_dns_zone_ids           = [module.private_dns_blob.zone_id]
    }

    sql = {
      private_connection_resource_id = azurerm_mssql_server.this.id
      subresource_names              = ["sqlServer"]
      private_dns_zone_ids           = [module.private_dns_sql.zone_id]
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
