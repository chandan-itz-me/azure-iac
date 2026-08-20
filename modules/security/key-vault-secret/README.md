# security/key-vault-secret

Manages secrets inside an existing Key Vault. Values can be supplied directly or
generated as random passwords via `generate_value`, in which case this module owns
the `random` provider so callers do not need to declare it themselves.

## Usage

```hcl
module "app_secrets" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/security/key-vault-secret?ref=v1.0.0"

  key_vault_id = module.key_vault.id

  secrets = {
    db-password = {
      generate_value = true
    }
    api-key = {
      value        = var.api_key
      content_type = "text/plain"
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
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.9.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the Key Vault the secrets are created in. | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets, keyed by a unique secret name. Set generate\_value to true to have a random value generated instead of supplying value. | <pre>map(object({<br/>    value             = optional(string)<br/>    content_type      = optional(string)<br/>    expiration_date   = optional(string)<br/>    not_before_date   = optional(string)<br/>    generate_value    = optional(bool, false)<br/>    generated_length  = optional(number, 32)<br/>    generated_special = optional(bool, true)<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every secret created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | Map of secret names to their versionless Key Vault Secret IDs. |
| <a name="output_versions"></a> [versions](#output\_versions) | Map of secret names to their current version. |
<!-- END_TF_DOCS -->
