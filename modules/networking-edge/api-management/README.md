# networking-edge/api-management

Creates an Azure API Management instance with legacy TLS/SSL protocols disabled by
default, optional virtual network integration, a managed identity, and maps of APIs,
products, named values and backends. Product-to-API associations and OpenAPI/WSDL
imports are driven entirely through input maps.

## Usage

```hcl
module "apim" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking-edge/api-management?ref=v1.0.0"

  name                = "platform-apim"
  resource_group_name = azurerm_resource_group.edge.name
  location            = azurerm_resource_group.edge.location
  publisher_name      = "Platform Team"
  publisher_email     = "platform@example.com"
  sku_name            = "Standard_1"

  apis = {
    orders = {
      display_name = "Orders API"
      path         = "orders"
      service_url  = "https://orders.internal.example.com"
    }
  }

  products = {
    partner = {
      display_name = "Partner"
      api_keys     = ["orders"]
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
| [azurerm_api_management.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_api.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_backend.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_backend) | resource |
| [azurerm_api_management_custom_domain.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_custom_domain) | resource |
| [azurerm_api_management_named_value.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_product.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_api.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_api) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the API Management instance is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the API Management instance. | `string` | n/a | yes |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | Email address of the API publisher, used for notifications. | `string` | n/a | yes |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | Name of the API publisher, shown to API consumers. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the API Management instance is created in. | `string` | n/a | yes |
| <a name="input_apis"></a> [apis](#input\_apis) | Map of APIs to publish, keyed by a unique API name. | <pre>map(object({<br/>    display_name = string<br/>    path         = string<br/>    revision     = optional(string, "1")<br/>    protocols    = optional(list(string), ["https"])<br/>    service_url  = optional(string)<br/>    import = optional(object({<br/>      content_format = string<br/>      content_value  = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | Map of backends, keyed by a unique backend name. | <pre>map(object({<br/>    protocol    = string<br/>    url         = string<br/>    description = optional(string)<br/>    resource_id = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_domain_gateway"></a> [custom\_domain\_gateway](#input\_custom\_domain\_gateway) | Custom domain configuration for the API Management gateway endpoint. Set to null to use the default *.azure-api.net hostname. | <pre>object({<br/>    host_name                    = string<br/>    key_vault_secret_id          = string<br/>    negotiate_client_certificate = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | IDs of user-assigned managed identities attached to the API Management instance. Required when identity\_type includes UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to the API Management instance. | `string` | `"SystemAssigned"` | no |
| <a name="input_min_api_version"></a> [min\_api\_version](#input\_min\_api\_version) | Limits the API Management control plane API calls to a minimum API version. Set to null to allow all versions. | `string` | `null` | no |
| <a name="input_named_values"></a> [named\_values](#input\_named\_values) | Map of named values (API Management properties), keyed by a unique name. Entries with secret = true are marked sensitive. | <pre>map(object({<br/>    display_name = string<br/>    value        = string<br/>    secret       = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_products"></a> [products](#input\_products) | Map of products, keyed by a unique product name. api\_keys references keys from var.apis to associate. | <pre>map(object({<br/>    display_name          = string<br/>    description           = optional(string)<br/>    subscription_required = optional(bool, true)<br/>    approval_required     = optional(bool, false)<br/>    published             = optional(bool, true)<br/>    api_keys              = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_security_protocols"></a> [security\_protocols](#input\_security\_protocols) | Legacy TLS/SSL protocol and cipher toggles. All disabled by default to enforce TLS 1.2+. | <pre>object({<br/>    enable_backend_ssl30      = optional(bool, false)<br/>    enable_backend_tls10      = optional(bool, false)<br/>    enable_backend_tls11      = optional(bool, false)<br/>    enable_frontend_ssl30     = optional(bool, false)<br/>    enable_frontend_tls10     = optional(bool, false)<br/>    enable_frontend_tls11     = optional(bool, false)<br/>    enable_triple_des_ciphers = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU of the API Management instance, in the format {tier}\_{capacity}, e.g. Developer\_1, Standard\_1, Premium\_2. | `string` | `"Developer_1"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet used for virtual network integration. Required when virtual\_network\_type is External or Internal. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_type"></a> [virtual\_network\_type](#input\_virtual\_network\_type) | Type of virtual network integration for the API Management instance. | `string` | `"None"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_ids"></a> [api\_ids](#output\_api\_ids) | Map of API names to their IDs. |
| <a name="output_gateway_url"></a> [gateway\_url](#output\_gateway\_url) | Gateway URL of the API Management instance. |
| <a name="output_id"></a> [id](#output\_id) | ID of the API Management instance. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the API Management instance's managed identity. |
<!-- END_TF_DOCS -->
