# networking-edge/front-door

Creates an Azure Front Door (Standard or Premium) profile with an endpoint, one or
more origin groups with health probes, origins, routes, and optional custom domains
with a WAF security policy association. DNS records for custom domains are managed
outside this module.

## Usage

```hcl
module "front_door" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking-edge/front-door?ref=v1.0.0"

  name                 = "global-fd"
  resource_group_name  = azurerm_resource_group.edge.name
  sku_name             = "Standard_AzureFrontDoor"
  endpoint_name        = "app"

  origin_groups = {
    app = {
      health_probe = { path = "/healthz" }
    }
  }

  origins = {
    app-primary = {
      origin_group_key = "app"
      host_name        = "app.internal.example.com"
    }
  }

  routes = {
    app = {
      origin_group_key  = "app"
      patterns_to_match = ["/*"]
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
