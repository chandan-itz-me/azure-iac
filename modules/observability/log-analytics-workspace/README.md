# observability/log-analytics-workspace

Creates a Log Analytics workspace with configurable retention and daily
ingestion cap, optional linked solutions (e.g. Security, ContainerInsights)
and an optional automation account linked service. Public ingestion and
query are enabled by default for compatibility; tighten both to false and
front the workspace with a private link scope in stricter environments.

## Usage

```hcl
module "log_analytics" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/observability/log-analytics-workspace?ref=v1.0.0"

  name                = "platform-law"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  retention_in_days   = 90

  solutions = {
    container-insights = {
      solution_name = "ContainerInsights"
      publisher     = "Microsoft"
      product       = "OMSGallery/ContainerInsights"
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
| [azurerm_log_analytics_linked_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) | resource |
| [azurerm_log_analytics_solution.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the workspace is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Log Analytics workspace. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the workspace is created in. | `string` | n/a | yes |
| <a name="input_daily_quota_gb"></a> [daily\_quota\_gb](#input\_daily\_quota\_gb) | Daily ingestion cap in GB. Use -1 for unlimited (default provider behaviour). | `number` | `null` | no |
| <a name="input_internet_ingestion_enabled"></a> [internet\_ingestion\_enabled](#input\_internet\_ingestion\_enabled) | Whether data ingestion over the public internet is allowed. Defaults to true for compatibility; tighten to false and use a private link scope for stricter environments. | `bool` | `true` | no |
| <a name="input_internet_query_enabled"></a> [internet\_query\_enabled](#input\_internet\_query\_enabled) | Whether querying the workspace over the public internet is allowed. Defaults to true for compatibility; tighten to false and use a private link scope for stricter environments. | `bool` | `true` | no |
| <a name="input_linked_service"></a> [linked\_service](#input\_linked\_service) | Automation account linked service configuration for the workspace. | <pre>object({<br/>    automation_account_id = string<br/>  })</pre> | `null` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain workspace data, between 30 and 730. | `number` | `30` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Pricing tier of the workspace. | `string` | `"PerGB2018"` | no |
| <a name="input_solutions"></a> [solutions](#input\_solutions) | Map of Log Analytics solutions to link to the workspace, keyed by an arbitrary name (e.g. "security", "container-insights"). | <pre>map(object({<br/>    solution_name = string<br/>    publisher     = string<br/>    product       = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | ARM resource ID of the Log Analytics workspace. |
| <a name="output_primary_shared_key"></a> [primary\_shared\_key](#output\_primary\_shared\_key) | Primary shared key used to connect agents to the workspace. |
| <a name="output_solution_ids"></a> [solution\_ids](#output\_solution\_ids) | Map of solution name to its resource ID. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Workspace (customer) ID GUID of the Log Analytics workspace. |
<!-- END_TF_DOCS -->
