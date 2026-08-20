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
| [azurerm_cdn_frontdoor_custom_domain.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain_association) | resource |
| [azurerm_cdn_frontdoor_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_origin.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_security_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_security_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_endpoint_name"></a> [endpoint\_name](#input\_endpoint\_name) | Name of the Front Door endpoint. Forms part of the generated *.azurefd.net hostname. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Azure Front Door profile. | `string` | n/a | yes |
| <a name="input_origin_groups"></a> [origin\_groups](#input\_origin\_groups) | Map of origin groups, keyed by a unique origin group name. | <pre>map(object({<br/>    session_affinity_enabled                                  = optional(bool, false)<br/>    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)<br/>    health_probe = optional(object({<br/>      protocol            = optional(string, "Https")<br/>      interval_in_seconds = optional(number, 100)<br/>      request_type        = optional(string, "GET")<br/>      path                = optional(string, "/")<br/>    }))<br/>    load_balancing = optional(object({<br/>      additional_latency_in_milliseconds = optional(number, 50)<br/>      sample_size                        = optional(number, 4)<br/>      successful_samples_required        = optional(number, 3)<br/>    }), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_origins"></a> [origins](#input\_origins) | Map of origins, keyed by a unique origin name. Each origin belongs to one origin group. | <pre>map(object({<br/>    origin_group_key               = string<br/>    host_name                      = string<br/>    origin_host_header             = optional(string)<br/>    certificate_name_check_enabled = optional(bool, true)<br/>    priority                       = optional(number, 1)<br/>    weight                         = optional(number, 500)<br/>    http_port                      = optional(number, 80)<br/>    https_port                     = optional(number, 443)<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Front Door profile is created in. | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of routes, keyed by a unique route name. Each route forwards matched patterns to an origin group. | <pre>map(object({<br/>    origin_group_key       = string<br/>    patterns_to_match      = list(string)<br/>    supported_protocols    = optional(list(string), ["Http", "Https"])<br/>    forwarding_protocol    = optional(string, "HttpsOnly")<br/>    https_redirect_enabled = optional(bool, true)<br/>    link_to_default_domain = optional(bool, true)<br/>    custom_domain_keys     = optional(list(string), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_custom_domains"></a> [custom\_domains](#input\_custom\_domains) | Map of custom domains associated with routes, keyed by a unique domain name. | <pre>map(object({<br/>    host_name        = string<br/>    dns_zone_id      = optional(string)<br/>    certificate_type = optional(string, "ManagedCertificate")<br/>  }))</pre> | `{}` | no |
| <a name="input_security_policy"></a> [security\_policy](#input\_security\_policy) | WAF security policy wiring applied to the custom domains and default endpoint. Set to null to skip WAF association. | <pre>object({<br/>    waf_policy_id      = string<br/>    custom_domain_keys = optional(list(string), [])<br/>    patterns_to_match  = optional(list(string), ["/*"])<br/>    associate_endpoint = optional(bool, true)<br/>  })</pre> | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU of the Front Door profile. | `string` | `"Standard_AzureFrontDoor"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_custom_domain_ids"></a> [custom\_domain\_ids](#output\_custom\_domain\_ids) | Map of custom domain names to their IDs. |
| <a name="output_endpoint_hostname"></a> [endpoint\_hostname](#output\_endpoint\_hostname) | Default hostname of the Front Door endpoint. |
| <a name="output_profile_id"></a> [profile\_id](#output\_profile\_id) | ID of the Front Door profile. |
| <a name="output_route_ids"></a> [route\_ids](#output\_route\_ids) | Map of route names to their IDs. |
<!-- END_TF_DOCS -->
