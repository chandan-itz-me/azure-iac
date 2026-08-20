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
<!-- END_TF_DOCS -->
