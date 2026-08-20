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
| [azurerm_linux_function_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_linux_function_app_slot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot) | resource |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_windows_function_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [azurerm_windows_function_app_slot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app_slot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the function app is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the function app. | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system family of the function app, linux or windows. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the function app is created in. | `string` | n/a | yes |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | Access key of the storage account used for function app content and triggers. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of an existing storage account used for function app content and triggers. | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Map of application settings applied to the function app. | `map(string)` | `{}` | no |
| <a name="input_create_service_plan"></a> [create\_service\_plan](#input\_create\_service\_plan) | Whether an App Service Plan is created by this module. Set to false to attach to an existing plan via service\_plan\_id. | `bool` | `true` | no |
| <a name="input_dotnet_version"></a> [dotnet\_version](#input\_dotnet\_version) | .NET version for the application stack, e.g. "8.0". Only used when relevant to os\_type. | `string` | `null` | no |
| <a name="input_function_app_slots"></a> [function\_app\_slots](#input\_function\_app\_slots) | Map of deployment slots to create, keyed by a unique slot name. | <pre>map(object({<br/>    app_settings = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Whether the function app only accepts HTTPS traffic. | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs. Required when identity\_type includes UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to the function app. | `string` | `"SystemAssigned"` | no |
| <a name="input_java_version"></a> [java\_version](#input\_java\_version) | Java version for the application stack, e.g. "17". Only used when relevant to os\_type. | `string` | `null` | no |
| <a name="input_node_version"></a> [node\_version](#input\_node\_version) | Node.js version for the application stack, e.g. "20". Only used when relevant to os\_type. | `string` | `null` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | Python version for the application stack, e.g. "3.12". Only used for linux function apps. | `string` | `null` | no |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | ID of an existing App Service Plan. Required when create\_service\_plan is false. | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU name of the App Service Plan created by this module, e.g. Y1, EP1, P1v3. Only used when create\_service\_plan is true. | `string` | `"Y1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_subnet_id"></a> [virtual\_network\_subnet\_id](#input\_virtual\_network\_subnet\_id) | ID of the subnet used for VNet integration. VNet integration is disabled when null. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | Default hostname of the function app. |
| <a name="output_function_app_id"></a> [function\_app\_id](#output\_function\_app\_id) | ID of the function app. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the function app's system-assigned managed identity, if enabled. |
| <a name="output_outbound_ip_addresses"></a> [outbound\_ip\_addresses](#output\_outbound\_ip\_addresses) | Comma-separated list of outbound IP addresses used by the function app. |
<!-- END_TF_DOCS -->
