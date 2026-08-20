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
| [azurerm_monitor_action_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_activity_log_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_metric_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the alert and action group resources are created in. | `string` | n/a | yes |
| <a name="input_action_groups"></a> [action\_groups](#input\_action\_groups) | Map of action groups to create, keyed by an arbitrary name. | <pre>map(object({<br/>    name       = string<br/>    short_name = string<br/><br/>    email_receiver = optional(list(object({<br/>      name                    = string<br/>      email_address           = string<br/>      use_common_alert_schema = optional(bool, true)<br/>    })), [])<br/><br/>    sms_receiver = optional(list(object({<br/>      name         = string<br/>      country_code = string<br/>      phone_number = string<br/>    })), [])<br/><br/>    webhook_receiver = optional(list(object({<br/>      name                    = string<br/>      service_uri             = string<br/>      use_common_alert_schema = optional(bool, true)<br/>    })), [])<br/><br/>    azure_function_receiver = optional(list(object({<br/>      name                     = string<br/>      function_app_resource_id = string<br/>      function_name            = string<br/>      http_trigger_url         = string<br/>      use_common_alert_schema  = optional(bool, true)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_activity_log_alerts"></a> [activity\_log\_alerts](#input\_activity\_log\_alerts) | Map of activity log alerts to create, keyed by an arbitrary name. | <pre>map(object({<br/>    name        = string<br/>    scopes      = list(string)<br/>    description = optional(string, null)<br/>    enabled     = optional(bool, true)<br/><br/>    criteria = object({<br/>      category       = string<br/>      operation_name = optional(string, null)<br/>      resource_type  = optional(string, null)<br/>      status         = optional(string, null)<br/>      level          = optional(string, null)<br/>    })<br/><br/>    action_group_ids = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region the log-based scheduled query rules are deployed to. Not used by metric alerts, activity log alerts or action groups, which are regionless. | `string` | `null` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | Map of metric alerts to create, keyed by an arbitrary name. | <pre>map(object({<br/>    name             = string<br/>    scopes           = list(string)<br/>    description      = optional(string, null)<br/>    severity         = optional(number, 3)<br/>    frequency        = optional(string, "PT1M")<br/>    window_size      = optional(string, "PT5M")<br/>    auto_mitigate    = optional(bool, true)<br/>    enabled          = optional(bool, true)<br/>    action_group_ids = optional(list(string), [])<br/><br/>    criteria = optional(list(object({<br/>      metric_namespace = string<br/>      metric_name      = string<br/>      aggregation      = string<br/>      operator         = string<br/>      threshold        = number<br/>      dimension = optional(list(object({<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      })), [])<br/>    })), [])<br/><br/>    dynamic_criteria = optional(list(object({<br/>      metric_namespace         = string<br/>      metric_name              = string<br/>      aggregation              = string<br/>      operator                 = string<br/>      alert_sensitivity        = string<br/>      evaluation_total_count   = optional(number, 4)<br/>      evaluation_failure_count = optional(number, 4)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_scheduled_query_rules"></a> [scheduled\_query\_rules](#input\_scheduled\_query\_rules) | Map of log-based scheduled query rule alerts (v2) to create, keyed by an arbitrary name. | <pre>map(object({<br/>    name                    = string<br/>    scopes                  = list(string)<br/>    description             = optional(string, null)<br/>    severity                = optional(number, 3)<br/>    evaluation_frequency    = optional(string, "PT5M")<br/>    window_duration         = optional(string, "PT5M")<br/>    auto_mitigation_enabled = optional(bool, true)<br/>    enabled                 = optional(bool, true)<br/>    action_group_ids        = optional(list(string), [])<br/><br/>    criteria = object({<br/>      query                   = string<br/>      time_aggregation_method = string<br/>      threshold               = number<br/>      operator                = string<br/>      dimension = optional(list(object({<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      })), [])<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_action_group_ids"></a> [action\_group\_ids](#output\_action\_group\_ids) | Map of action group name to its resource ID. |
| <a name="output_activity_log_alert_ids"></a> [activity\_log\_alert\_ids](#output\_activity\_log\_alert\_ids) | Map of activity log alert name to its resource ID. |
| <a name="output_metric_alert_ids"></a> [metric\_alert\_ids](#output\_metric\_alert\_ids) | Map of metric alert name to its resource ID. |
| <a name="output_scheduled_query_rule_ids"></a> [scheduled\_query\_rule\_ids](#output\_scheduled\_query\_rule\_ids) | Map of scheduled query rule name to its resource ID. |
<!-- END_TF_DOCS -->
