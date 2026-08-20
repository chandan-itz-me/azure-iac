# security/key-vault-certificate

Manages certificates inside an existing Key Vault, either by importing an existing
PFX/PEM (base64-encoded, sensitive) or by having Key Vault generate and auto-renew
one from a certificate policy (self-signed or through an integrated CA). A
certificate_policy is always supplied to the underlying API; for imports set
`issuer_name = "Unknown"`.

## Usage

```hcl
module "app_cert" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/security/key-vault-certificate?ref=v1.0.0"

  key_vault_id = module.key_vault.id

  certificates = {
    app = {
      certificate_policy = {
        subject             = "CN=app.example.com"
        validity_in_months  = 12
        subject_alternative_names = {
          dns_names = ["app.example.com"]
        }
        lifetime_action = {
          lifetime_percentage = 80
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
| [azurerm_key_vault_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | Map of certificates, keyed by a unique certificate name. Set import to bring an existing certificate, or leave it null to have Key Vault generate one from certificate\_policy. certificate\_policy is always required by the underlying API, even for imports (use issuer\_name = "Unknown" in that case). | <pre>map(object({<br/>    import = optional(object({<br/>      contents = string<br/>      password = optional(string)<br/>    }))<br/>    certificate_policy = object({<br/>      issuer_name  = optional(string, "Self")<br/>      exportable   = optional(bool, true)<br/>      key_type     = optional(string, "RSA")<br/>      key_size     = optional(number, 2048)<br/>      curve        = optional(string)<br/>      reuse_key    = optional(bool, true)<br/>      content_type = optional(string, "application/x-pkcs12")<br/><br/>      subject            = string<br/>      validity_in_months = optional(number, 12)<br/>      key_usage          = optional(list(string), ["digitalSignature", "keyEncipherment"])<br/>      extended_key_usage = optional(list(string), [])<br/>      subject_alternative_names = optional(object({<br/>        dns_names = optional(list(string), [])<br/>        emails    = optional(list(string), [])<br/>        upns      = optional(list(string), [])<br/>      }))<br/><br/>      lifetime_action = optional(object({<br/>        action_type         = optional(string, "AutoRenew")<br/>        lifetime_percentage = optional(number)<br/>        days_before_expiry  = optional(number)<br/>      }), {})<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of the Key Vault the certificates are created in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every certificate created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_certificate_ids"></a> [certificate\_ids](#output\_certificate\_ids) | Map of certificate names to their versionless Key Vault Certificate IDs. |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | Map of certificate names to the versionless ID of the backing Key Vault secret. |
| <a name="output_thumbprints"></a> [thumbprints](#output\_thumbprints) | Map of certificate names to their SHA-1 thumbprints. |
| <a name="output_versions"></a> [versions](#output\_versions) | Map of certificate names to their current version. |
<!-- END_TF_DOCS -->
