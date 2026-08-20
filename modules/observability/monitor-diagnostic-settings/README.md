# observability/monitor-diagnostic-settings

Creates one or more Azure Monitor diagnostic settings against any
resource ID, forwarding logs and metrics to a Log Analytics workspace,
a storage account or an Event Hub. Each entry must set exactly one
destination.

## Usage

```hcl
module "diagnostics" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/observability/monitor-diagnostic-settings?ref=v1.0.0"

  diagnostic_settings = {
    vnet-to-law = {
      target_resource_id         = module.vnet.vnet_id
      log_analytics_workspace_id = module.log_analytics.id

      enabled_logs = [
        { category_group = "allLogs" }
      ]

      metrics = [
        { category = "AllMetrics" }
      ]
    }
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
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | Map of diagnostic settings to create, keyed by a logical name. Each entry must set exactly one of log\_analytics\_workspace\_id, storage\_account\_id or eventhub\_authorization\_rule\_id as its destination. | <pre>map(object({<br/>    target_resource_id             = string<br/>    log_analytics_workspace_id     = optional(string, null)<br/>    storage_account_id             = optional(string, null)<br/>    eventhub_authorization_rule_id = optional(string, null)<br/>    eventhub_name                  = optional(string, null)<br/><br/>    enabled_logs = optional(list(object({<br/>      category       = optional(string, null)<br/>      category_group = optional(string, null)<br/>    })), [])<br/><br/>    metrics = optional(list(object({<br/>      category = string<br/>      enabled  = optional(bool, true)<br/>    })), [])<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_diagnostic_setting_ids"></a> [diagnostic\_setting\_ids](#output\_diagnostic\_setting\_ids) | Map of diagnostic setting name to its resource ID. |
<!-- END_TF_DOCS -->
