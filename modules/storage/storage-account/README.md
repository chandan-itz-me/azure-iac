# storage/storage-account

Creates a general-purpose v2 storage account with secure defaults: public network
access disabled, TLS 1.2 minimum, network rules with a default-deny action, blob
versioning and soft delete. Supports blob containers, file shares, queues, tables,
customer-managed key encryption and lifecycle management policies.

## Usage

```hcl
module "storage_account" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/storage/storage-account?ref=v1.0.0"

  name                = "platformdatastore"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  account_replication_type = "GRS"

  network_rules = {
    default_action              = "Deny"
    virtual_network_subnet_ids  = [module.subnets.subnet_ids["app"]]
  }

  containers = {
    uploads = { container_access_type = "private" }
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
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_storage_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) | resource |
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the storage account is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the storage account. Must be globally unique, lowercase alphanumeric, 3-24 characters. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the storage account is created in. | `string` | n/a | yes |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Kind of storage account. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Replication strategy for the storage account. | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Performance tier of the storage account. | `string` | `"Standard"` | no |
| <a name="input_blob_properties"></a> [blob\_properties](#input\_blob\_properties) | Blob service properties for the storage account. | <pre>object({<br/>    versioning_enabled              = optional(bool, true)<br/>    change_feed_enabled             = optional(bool, false)<br/>    delete_retention_days           = optional(number, 7)<br/>    container_delete_retention_days = optional(number, 7)<br/>  })</pre> | `{}` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Map of blob containers to create, keyed by container name. | <pre>map(object({<br/>    container_access_type = optional(string, "private")<br/>  }))</pre> | `{}` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | Optional customer-managed key configuration for encryption at rest. Requires a user-assigned identity with access to the key vault. | <pre>object({<br/>    enabled                   = bool<br/>    key_vault_id              = string<br/>    key_name                  = string<br/>    key_version               = optional(string)<br/>    user_assigned_identity_id = string<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "key_name": null,<br/>  "key_vault_id": null,<br/>  "key_version": null,<br/>  "user_assigned_identity_id": null<br/>}</pre> | no |
| <a name="input_file_shares"></a> [file\_shares](#input\_file\_shares) | Map of file shares to create, keyed by share name. | <pre>map(object({<br/>    quota_gb = number<br/>  }))</pre> | `{}` | no |
| <a name="input_https_traffic_only_enabled"></a> [https\_traffic\_only\_enabled](#input\_https\_traffic\_only\_enabled) | Whether only HTTPS traffic is permitted to the storage account. | `bool` | `true` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Map of blob lifecycle management rules, keyed by rule name. | <pre>map(object({<br/>    prefix_match               = optional(list(string), [])<br/>    tier_to_cool_after_days    = optional(number, null)<br/>    tier_to_archive_after_days = optional(number, null)<br/>    delete_after_days          = optional(number, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | Minimum TLS version accepted by the storage account. | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Network rules restricting access to the storage account. Set to null to disable network rules entirely (not recommended). | <pre>object({<br/>    default_action             = optional(string, "Deny")<br/>    bypass                     = optional(list(string), ["AzureServices"])<br/>    ip_rules                   = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the storage account is enabled. Disabled by default; use private endpoints or network\_rules for access. | `bool` | `false` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | Map of storage queues to create, keyed by queue name. | `map(object({}))` | `{}` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Whether Shared Key authorization is allowed. Prefer disabling this and using Azure AD (RBAC) authentication where possible. | `bool` | `true` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | Map of storage tables to create, keyed by table name. | `map(object({}))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | Map of container name to container resource ID. |
| <a name="output_id"></a> [id](#output\_id) | ID of the storage account. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the storage account's system-assigned managed identity. |
| <a name="output_name"></a> [name](#output\_name) | Name of the storage account. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | Primary access key of the storage account. |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | Primary blob service endpoint of the storage account. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | Primary connection string of the storage account. |
| <a name="output_share_ids"></a> [share\_ids](#output\_share\_ids) | Map of file share name to file share resource ID. |
<!-- END_TF_DOCS -->
