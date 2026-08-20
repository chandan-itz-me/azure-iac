# observability/monitor-alerts

Creates Azure Monitor action groups plus metric alerts, activity log
alerts and log-based scheduled query rule alerts (v2), all keyed by
logical names so a single instance of this module can manage an
environment's full alerting surface.

## Usage

```hcl
module "alerts" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/observability/monitor-alerts?ref=v1.0.0"

  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  action_groups = {
    ops = {
      name       = "ops-oncall"
      short_name = "ops"

      email_receiver = [
        { name = "oncall", email_address = "oncall@example.com" }
      ]
    }
  }

  metric_alerts = {
    high-cpu = {
      name   = "vmss-high-cpu"
      scopes = [module.vmss.id]

      criteria = [{
        metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
        metric_name       = "Percentage CPU"
        aggregation       = "Average"
        operator          = "GreaterThan"
        threshold         = 80
      }]

      action_group_ids = [module.alerts.action_group_ids["ops"]]
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
