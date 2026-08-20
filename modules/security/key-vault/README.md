# security/key-vault

Creates a Key Vault secured by default: RBAC authorization instead of access
policies, purge protection enabled, a 90-day soft-delete retention, public network
access disabled, and a default-deny network ACL. Access policies are supported as a
fallback when `enable_rbac_authorization` is set to `false`. Send diagnostic logs to
Log Analytics by composing this module with an `observability` logging module and
`azurerm_monitor_diagnostic_setting` targeting this module's `id` output.

## Usage

```hcl
module "key_vault" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/security/key-vault?ref=v1.0.0"

  name                = "platform-kv"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  network_acls = {
    virtual_network_subnet_ids = [module.subnets.subnet_ids["app"]]
  }

  keys = {
    encryption = {
      key_type = "RSA"
      key_size = 2048
      key_opts = ["decrypt", "encrypt", "wrapKey", "unwrapKey"]
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
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the Key Vault is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Key Vault. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Key Vault is created in. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD tenant ID the Key Vault trusts for authentication. | `string` | n/a | yes |
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | Map of access policies, keyed by a unique name. Only applied when enable\_rbac\_authorization is false. | <pre>map(object({<br/>    object_id               = string<br/>    application_id          = optional(string)<br/>    key_permissions         = optional(list(string), [])<br/>    secret_permissions      = optional(list(string), [])<br/>    certificate_permissions = optional(list(string), [])<br/>    storage_permissions     = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Whether Azure RBAC is used to authorize data plane access instead of access policies. Preferred over access policies. | `bool` | `true` | no |
| <a name="input_keys"></a> [keys](#input\_keys) | Map of keys to create in the Key Vault, keyed by a unique key name. | <pre>map(object({<br/>    key_type = string<br/>    key_size = optional(number)<br/>    curve    = optional(string)<br/>    key_opts = list(string)<br/>    rotation_policy = optional(object({<br/>      expire_after         = optional(string)<br/>      notify_before_expiry = optional(string)<br/>      automatic_renew_days = optional(number)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACL rules restricting access to the Key Vault. | <pre>object({<br/>    default_action             = optional(string, "Deny")<br/>    bypass                     = optional(string, "AzureServices")<br/>    ip_rules                   = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether the Key Vault is reachable from the public internet, subject to network\_acls. | `bool` | `false` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Whether purge protection is enabled. Once enabled this cannot be disabled. | `bool` | `true` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU of the Key Vault. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Number of days that soft-deleted items are retained, between 7 and 90. | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ID of the Key Vault. |
| <a name="output_key_ids"></a> [key\_ids](#output\_key\_ids) | Map of key names to their versionless Key Vault Key IDs. |
| <a name="output_key_versions"></a> [key\_versions](#output\_key\_versions) | Map of key names to their current version. |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | URI of the Key Vault, used to reference secrets, keys and certificates. |
<!-- END_TF_DOCS -->
