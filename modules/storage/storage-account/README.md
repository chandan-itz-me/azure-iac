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
<!-- END_TF_DOCS -->
