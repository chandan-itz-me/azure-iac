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
<!-- END_TF_DOCS -->
