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
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | Map of backend address pools, keyed by a unique pool name. | <pre>map(object({<br/>    ip_addresses = optional(list(string))<br/>    fqdns        = optional(list(string))<br/>  }))</pre> | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | Map of backend HTTP settings, keyed by a unique settings name. | <pre>map(object({<br/>    port                  = number<br/>    protocol              = optional(string, "Https")<br/>    cookie_based_affinity = optional(string, "Disabled")<br/>    request_timeout       = optional(number, 30)<br/>    path                  = optional(string)<br/>    host_name             = optional(string)<br/>    probe_key             = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | Map of HTTP listeners, keyed by a unique listener name. | <pre>map(object({<br/>    frontend_port        = number<br/>    protocol             = optional(string, "Https")<br/>    host_name            = optional(string)<br/>    require_sni          = optional(bool, false)<br/>    use_private_frontend = optional(bool, false)<br/>    key_vault_secret_id  = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the application gateway is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the application gateway. | `string` | n/a | yes |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | Map of request routing rules, keyed by a unique rule name. | <pre>map(object({<br/>    priority                   = number<br/>    rule_type                  = optional(string, "Basic")<br/>    http_listener_key          = string<br/>    backend_address_pool_key   = optional(string)<br/>    backend_http_settings_key  = optional(string)<br/>    redirect_configuration_key = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the application gateway is created in. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet the gateway\_ip\_configuration is attached to. Must be dedicated to Application Gateway. | `string` | n/a | yes |
| <a name="input_autoscale_max_capacity"></a> [autoscale\_max\_capacity](#input\_autoscale\_max\_capacity) | Maximum instance capacity used for autoscaling. | `number` | `10` | no |
| <a name="input_autoscale_min_capacity"></a> [autoscale\_min\_capacity](#input\_autoscale\_min\_capacity) | Minimum instance capacity used for autoscaling. | `number` | `2` | no |
| <a name="input_create_public_ip"></a> [create\_public\_ip](#input\_create\_public\_ip) | Whether this module creates the public IP used by the frontend IP configuration. | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | IDs of user-assigned managed identities attached to the gateway. Required when http\_listeners reference key\_vault\_secret\_id. | `list(string)` | `[]` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Static private IP address added as an additional frontend IP configuration. Omit for public-only listeners. | `string` | `null` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | Map of custom health probes, keyed by a unique probe name. | <pre>map(object({<br/>    protocol            = optional(string, "Http")<br/>    path                = string<br/>    host                = optional(string, "127.0.0.1")<br/>    interval            = optional(number, 30)<br/>    timeout             = optional(number, 30)<br/>    unhealthy_threshold = optional(number, 3)<br/>  }))</pre> | `{}` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Allocation method of the public IP created by this module. | `string` | `"Static"` | no |
| <a name="input_public_ip_id"></a> [public\_ip\_id](#input\_public\_ip\_id) | ID of an existing public IP to use for the frontend IP configuration. Required when create\_public\_ip is false. | `string` | `null` | no |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | SKU of the public IP created by this module. | `string` | `"Standard"` | no |
| <a name="input_redirect_configurations"></a> [redirect\_configurations](#input\_redirect\_configurations) | Map of redirect configurations, keyed by a unique redirect name and referenced from request\_routing\_rules. | <pre>map(object({<br/>    redirect_type        = string<br/>    target_listener_key  = optional(string)<br/>    target_url           = optional(string)<br/>    include_path         = optional(bool, true)<br/>    include_query_string = optional(bool, true)<br/>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU name of the application gateway. | `string` | `"WAF_v2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_waf_configuration"></a> [waf\_configuration](#input\_waf\_configuration) | Web Application Firewall configuration. Only applies when sku\_name is WAF\_v2. | <pre>object({<br/>    enabled          = optional(bool, true)<br/>    firewall_mode    = optional(string, "Prevention")<br/>    rule_set_version = optional(string, "3.2")<br/>    disabled_rule_group = optional(list(object({<br/>      rule_group_name = string<br/>      rules           = optional(list(number))<br/>    })), [])<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_address_pool_ids"></a> [backend\_address\_pool\_ids](#output\_backend\_address\_pool\_ids) | Map of backend address pool names to their IDs. |
| <a name="output_id"></a> [id](#output\_id) | ID of the application gateway. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the gateway's identity, when a user-assigned identity is attached. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address associated with the application gateway frontend. |
<!-- END_TF_DOCS -->
