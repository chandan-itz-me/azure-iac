# compute/app-service

Creates a Linux or Windows Web App, optionally provisioning its App Service Plan, with VNet
integration, an optional custom domain bound to an App Service managed certificate, and a map of
deployment slots for blue/green or canary rollouts.

## Usage

```hcl
module "app_service" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/app-service?ref=v1.0.0"

  name                      = "storefront"
  resource_group_name       = azurerm_resource_group.app.name
  location                  = azurerm_resource_group.app.location
  os_type                   = "linux"
  sku_name                  = "P1v3"
  node_version              = "20-lts"
  virtual_network_subnet_id = module.subnet.subnet_id

  app_settings = {
    NODE_ENV = "production"
  }

  deployment_slots = {
    staging = {}
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
