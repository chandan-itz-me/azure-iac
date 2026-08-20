# database/azure-sql-database

Creates an Azure SQL logical server and one or more databases with public network
access disabled by default, TLS 1.2 minimum and short/long-term backup retention
policies. Supports SQL and/or Azure AD administrators, firewall and virtual network
rules, customer-managed key transparent data encryption, and extended auditing wired
to a storage account.

## Usage

```hcl
module "sql" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/database/azure-sql-database?ref=v1.0.0"

  name                = "platform-sql"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  azuread_administrator = {
    login_username = "sql-admins"
    object_id      = data.azuread_group.sql_admins.object_id
  }

  databases = {
    orders = {
      sku_name    = "GP_S_Gen5_2"
      max_size_gb = 64
    }
  }

  virtual_network_rules = {
    app = { subnet_id = module.subnets.subnet_ids["app"] }
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
