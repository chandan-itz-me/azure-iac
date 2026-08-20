# compute/function-app

Creates a Linux or Windows Function App, optionally provisioning its App Service Plan. The
backing storage account is deliberately kept out of scope: pass an existing account's name and
access key, composing this module with the `storage/s3-bucket`-equivalent storage account module
in your environment stack.

## Usage

```hcl
module "function_app" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/function-app?ref=v1.0.0"

  name                        = "orders-processor"
  resource_group_name         = azurerm_resource_group.app.name
  location                    = azurerm_resource_group.app.location
  os_type                     = "linux"
  sku_name                    = "EP1"
  storage_account_name        = azurerm_storage_account.functions.name
  storage_account_access_key  = azurerm_storage_account.functions.primary_access_key
  node_version                = "20"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
