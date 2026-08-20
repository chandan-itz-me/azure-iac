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
| [azurerm_mssql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_database_extended_auditing_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_extended_auditing_policy) | resource |
| [azurerm_mssql_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_transparent_data_encryption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_transparent_data_encryption) | resource |
| [azurerm_mssql_virtual_network_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the SQL server is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the SQL server. Must be globally unique. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the SQL server is created in. | `string` | n/a | yes |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | SQL authentication administrator login name. Leave null when using an Azure AD-only administrator. | `string` | `null` | no |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | SQL authentication administrator password. Leave null when using an Azure AD-only administrator. Never default this to a literal value. | `string` | `null` | no |
| <a name="input_auditing"></a> [auditing](#input\_auditing) | Extended auditing configuration wired to a storage account. Leave blob\_storage\_endpoint null to disable auditing. | <pre>object({<br/>    blob_storage_endpoint                   = optional(string, null)<br/>    storage_account_access_key_is_secondary = optional(bool, false)<br/>    retention_in_days                       = optional(number, 90)<br/>    database_auditing_enabled               = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_auditing_storage_account_access_key"></a> [auditing\_storage\_account\_access\_key](#input\_auditing\_storage\_account\_access\_key) | Access key for the storage account used by extended auditing. Never default this to a literal value. | `string` | `null` | no |
| <a name="input_azuread_administrator"></a> [azuread\_administrator](#input\_azuread\_administrator) | Azure AD administrator configuration for the SQL server. Preferred over SQL authentication. | <pre>object({<br/>    login_username              = string<br/>    object_id                   = string<br/>    tenant_id                   = optional(string, null)<br/>    azuread_authentication_only = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Map of SQL databases to create, keyed by database name. | <pre>map(object({<br/>    sku_name                    = optional(string, "GP_S_Gen5_2")<br/>    max_size_gb                 = optional(number, 32)<br/>    zone_redundant              = optional(bool, false)<br/>    create_mode                 = optional(string, "Default")<br/>    creation_source_database_id = optional(string, null)<br/>    short_term_retention_days   = optional(number, 7)<br/>    long_term_retention = optional(object({<br/>      weekly_retention  = optional(string, "P1W")<br/>      monthly_retention = optional(string, "P1M")<br/>      yearly_retention  = optional(string, "P1Y")<br/>      week_of_year      = optional(number, 1)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Map of firewall rules to create, keyed by rule name. | <pre>map(object({<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | Minimum TLS version accepted by the SQL server. | `string` | `"1.2"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the SQL server is enabled. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_transparent_data_encryption"></a> [transparent\_data\_encryption](#input\_transparent\_data\_encryption) | Customer-managed key configuration for transparent data encryption. Leave key\_vault\_key\_id null to use service-managed encryption. | <pre>object({<br/>    key_vault_key_id      = optional(string, null)<br/>    auto_rotation_enabled = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_user_assigned_identity_ids"></a> [user\_assigned\_identity\_ids](#input\_user\_assigned\_identity\_ids) | IDs of user-assigned managed identities attached to the SQL server. Required for customer-managed key TDE. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_rules"></a> [virtual\_network\_rules](#input\_virtual\_network\_rules) | Map of virtual network rules to create, keyed by rule name. | <pre>map(object({<br/>    subnet_id = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_database_ids"></a> [database\_ids](#output\_database\_ids) | Map of database name to resource ID. |
| <a name="output_fully_qualified_domain_name"></a> [fully\_qualified\_domain\_name](#output\_fully\_qualified\_domain\_name) | Fully qualified domain name of the SQL server. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the SQL server's system-assigned managed identity. |
| <a name="output_server_id"></a> [server\_id](#output\_server\_id) | ID of the SQL server. |
<!-- END_TF_DOCS -->
