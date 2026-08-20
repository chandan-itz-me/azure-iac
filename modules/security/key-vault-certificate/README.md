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
<!-- END_TF_DOCS -->
