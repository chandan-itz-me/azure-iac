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
| [azurerm_app_service_certificate_binding.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_managed_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_managed_certificate) | resource |
| [azurerm_linux_web_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app_slot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) | resource |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_windows_web_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app) | resource |
| [azurerm_windows_web_app_slot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app_slot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the web app is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the web app. | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system family of the web app, linux or windows. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the web app is created in. | `string` | n/a | yes |
| <a name="input_always_on"></a> [always\_on](#input\_always\_on) | Whether the web app is kept loaded even when there is no incoming traffic. | `bool` | `true` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Map of application settings applied to the web app. | `map(string)` | `{}` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | Map of connection strings applied to the web app, keyed by a unique connection string name. | <pre>map(object({<br/>    type  = string<br/>    value = string<br/>  }))</pre> | `{}` | no |
| <a name="input_create_service_plan"></a> [create\_service\_plan](#input\_create\_service\_plan) | Whether an App Service Plan is created by this module. Set to false to attach to an existing plan via service\_plan\_id. | `bool` | `true` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Custom domain bound to the web app with an App Service managed certificate. Disabled when null. | <pre>object({<br/>    hostname = string<br/>  })</pre> | `null` | no |
| <a name="input_deployment_slots"></a> [deployment\_slots](#input\_deployment\_slots) | Map of deployment slots to create, keyed by a unique slot name. | <pre>map(object({<br/>    app_settings = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_dotnet_version"></a> [dotnet\_version](#input\_dotnet\_version) | .NET version for the application stack, e.g. "8.0". Only used when relevant to os\_type. | `string` | `null` | no |
| <a name="input_http2_enabled"></a> [http2\_enabled](#input\_http2\_enabled) | Whether HTTP/2 is enabled for the web app. | `bool` | `true` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Whether the web app only accepts HTTPS traffic. | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs. Required when identity\_type includes UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to the web app. | `string` | `"SystemAssigned"` | no |
| <a name="input_java_version"></a> [java\_version](#input\_java\_version) | Java version for the application stack, e.g. "17". Only used when relevant to os\_type. | `string` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | Minimum TLS version accepted by the web app. | `string` | `"1.2"` | no |
| <a name="input_node_version"></a> [node\_version](#input\_node\_version) | Node.js version for the application stack, e.g. "20-lts". Only used for linux web apps. | `string` | `null` | no |
| <a name="input_php_version"></a> [php\_version](#input\_php\_version) | PHP version for the application stack, e.g. "8.3". Only used for linux web apps. | `string` | `null` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | Python version for the application stack, e.g. "3.12". Only used for linux web apps. | `string` | `null` | no |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | ID of an existing App Service Plan. Required when create\_service\_plan is false. | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU name of the App Service Plan created by this module, e.g. B1, P1v3. Only used when create\_service\_plan is true. | `string` | `"P1v3"` | no |
| <a name="input_sticky_settings"></a> [sticky\_settings](#input\_sticky\_settings) | App settings and connection strings that stay attached to a slot instead of swapping with it. | <pre>object({<br/>    app_setting_names       = optional(list(string), [])<br/>    connection_string_names = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_subnet_id"></a> [virtual\_network\_subnet\_id](#input\_virtual\_network\_subnet\_id) | ID of the subnet used for VNet integration. VNet integration is disabled when null. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | ID of the web app. |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | Default hostname of the web app. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the web app's system-assigned managed identity, if enabled. |
| <a name="output_plan_id"></a> [plan\_id](#output\_plan\_id) | ID of the App Service Plan used by the web app. |
| <a name="output_slot_ids"></a> [slot\_ids](#output\_slot\_ids) | Map of deployment slot IDs, keyed by slot name. |
<!-- END_TF_DOCS -->
