# compute/container-app

Creates an Azure Container App, optionally provisioning its Container Apps environment with VNet
integration and Log Analytics wiring. Containers, secrets and Dapr are configured from maps so
the same module backs single-container APIs and multi-container sidecar workloads.

## Usage

```hcl
module "container_app" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/container-app?ref=v1.0.0"

  name                        = "checkout-api"
  resource_group_name         = azurerm_resource_group.app.name
  location                    = azurerm_resource_group.app.location
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  infrastructure_subnet_id    = module.subnet.subnet_id

  containers = {
    api = {
      image  = "myregistry.azurecr.io/checkout-api:1.4.0"
      cpu    = 0.5
      memory = "1Gi"
      env = {
        ASPNETCORE_ENVIRONMENT = "Production"
      }
    }
  }

  ingress = {
    external_enabled = true
    target_port      = 8080
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
