# networking-edge/application-gateway

Creates an Azure Application Gateway v2 (WAF or Standard) with autoscaling, one or
more backend pools, health probes, HTTP/HTTPS listeners, and request routing rules.
Listeners can terminate TLS certificate-lessly by referencing a Key Vault secret,
provided a user-assigned identity with `Key Vault Secrets User` access is attached.

## Usage

```hcl
module "app_gateway" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking-edge/application-gateway?ref=v1.0.0"

  name                = "app-gw"
  resource_group_name = azurerm_resource_group.edge.name
  location            = azurerm_resource_group.edge.location
  subnet_id           = module.subnets.subnet_ids["gateway"]
  identity_ids        = [module.gateway_identity.identity_ids["app-gw"]]

  backend_address_pools = {
    app = { fqdns = ["app.internal.example.com"] }
  }

  probes = {
    app = { path = "/healthz" }
  }

  backend_http_settings = {
    app = { port = 443, probe_key = "app" }
  }

  http_listeners = {
    app = {
      frontend_port       = 443
      host_name           = "app.example.com"
      key_vault_secret_id = module.app_cert.secret_ids["app"]
    }
  }

  request_routing_rules = {
    app = {
      priority                  = 100
      http_listener_key         = "app"
      backend_address_pool_key  = "app"
      backend_http_settings_key = "app"
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
