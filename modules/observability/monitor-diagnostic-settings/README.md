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
<!-- END_TF_DOCS -->
