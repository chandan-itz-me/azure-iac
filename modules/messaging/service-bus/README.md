# messaging/service-bus

Creates a Service Bus namespace with optional queues, topics with nested
subscriptions and subscription rules, and namespace-level authorization rules.
Network access is denied by default; supply a `network_rule_set` (Premium sku
only) to allow specific IP ranges or subnets.

## Usage

```hcl
module "service_bus" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/messaging/service-bus?ref=v1.0.0"

  name                = "platform-sb"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Standard"

  queues = {
    orders = {
      max_size_in_megabytes = 2048
      requires_session      = true
    }
  }

  topics = {
    events = {
      subscriptions = {
        all = {
          max_delivery_count = 5
        }
      }
    }
  }

  authorization_rules = {
    send-only = {
      listen = false
      send   = true
      manage = false
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
| [azurerm_servicebus_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_namespace_disaster_recovery_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_disaster_recovery_config) | resource |
| [azurerm_servicebus_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription) | resource |
| [azurerm_servicebus_subscription_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription_rule) | resource |
| [azurerm_servicebus_topic.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the Service Bus namespace is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Service Bus namespace. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Service Bus namespace is created in. | `string` | n/a | yes |
| <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules) | Map of namespace-level authorization rules to create, keyed by rule name. | <pre>map(object({<br/>    listen = optional(bool, true)<br/>    send   = optional(bool, false)<br/>    manage = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Messaging units for the Premium sku (1, 2, 4, 8 or 16). Ignored for Basic/Standard. | `number` | `1` | no |
| <a name="input_disaster_recovery_alias_name"></a> [disaster\_recovery\_alias\_name](#input\_disaster\_recovery\_alias\_name) | Alias name for the geo-disaster recovery configuration. Required when enable\_disaster\_recovery\_config is true. | `string` | `null` | no |
| <a name="input_disaster_recovery_partner_namespace_id"></a> [disaster\_recovery\_partner\_namespace\_id](#input\_disaster\_recovery\_partner\_namespace\_id) | ID of the partner namespace to pair with for geo-disaster recovery. Required when enable\_disaster\_recovery\_config is true. | `string` | `null` | no |
| <a name="input_enable_disaster_recovery_config"></a> [enable\_disaster\_recovery\_config](#input\_enable\_disaster\_recovery\_config) | Whether a geo-disaster recovery (namespace pairing) alias is created for the namespace. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Managed identity configuration for the namespace. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_network_rule_set"></a> [network\_rule\_set](#input\_network\_rule\_set) | Network rule set restricting access to the namespace. Only supported on the Premium sku. | <pre>object({<br/>    default_action           = optional(string, "Deny")<br/>    trusted_services_allowed = optional(bool, false)<br/>    ip_rules                 = optional(list(string), [])<br/>    virtual_network_rules = optional(list(object({<br/>      subnet_id                                       = string<br/>      ignore_missing_virtual_network_service_endpoint = optional(bool, false)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the namespace is enabled. Disabled by default; use private endpoints or the network\_rule\_set for controlled access. | `bool` | `false` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | Map of Service Bus queues to create, keyed by queue name. | <pre>map(object({<br/>    max_size_in_megabytes                   = optional(number, 1024)<br/>    default_message_ttl                     = optional(string, null)<br/>    lock_duration                           = optional(string, null)<br/>    dead_lettering_on_message_expiration    = optional(bool, true)<br/>    requires_duplicate_detection            = optional(bool, false)<br/>    duplicate_detection_history_time_window = optional(string, null)<br/>    requires_session                        = optional(bool, false)<br/>    enable_partitioning                     = optional(bool, false)<br/>    max_delivery_count                      = optional(number, 10)<br/>  }))</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Pricing tier of the Service Bus namespace. | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | Map of Service Bus topics to create, keyed by topic name. | <pre>map(object({<br/>    max_size_in_megabytes                   = optional(number, 1024)<br/>    default_message_ttl                     = optional(string, null)<br/>    requires_duplicate_detection            = optional(bool, false)<br/>    duplicate_detection_history_time_window = optional(string, null)<br/>    enable_partitioning                     = optional(bool, false)<br/>    subscriptions = optional(map(object({<br/>      max_delivery_count                   = optional(number, 10)<br/>      lock_duration                        = optional(string, null)<br/>      default_message_ttl                  = optional(string, null)<br/>      dead_lettering_on_message_expiration = optional(bool, true)<br/>      requires_session                     = optional(bool, false)<br/>      forward_to                           = optional(string, null)<br/>      rules = optional(map(object({<br/>        filter_type = string<br/>        sql_filter  = optional(string, null)<br/>        correlation_filter = optional(object({<br/>          correlation_id = optional(string, null)<br/>          label          = optional(string, null)<br/>          message_id     = optional(string, null)<br/>          reply_to       = optional(string, null)<br/>          session_id     = optional(string, null)<br/>          to             = optional(string, null)<br/>        }), null)<br/>      })), {})<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Whether availability zones are enabled. Only supported on the Premium sku. | `bool` | `false` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the namespace managed identity, when identity is enabled. |
| <a name="output_namespace_id"></a> [namespace\_id](#output\_namespace\_id) | ID of the Service Bus namespace. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | Map of authorization rule name to its primary connection string. |
| <a name="output_queue_ids"></a> [queue\_ids](#output\_queue\_ids) | Map of queue name to queue ID. |
| <a name="output_subscription_ids"></a> [subscription\_ids](#output\_subscription\_ids) | Map of "topic.subscription" to subscription ID. |
| <a name="output_topic_ids"></a> [topic\_ids](#output\_topic\_ids) | Map of topic name to topic ID. |
<!-- END_TF_DOCS -->
