# messaging/event-hub

Creates an Event Hubs namespace with optional event hubs, consumer groups
and per-event-hub authorization rules. Network access is denied by default;
supply a `network_rulesets` block to allow specific IP ranges or subnets.

## Usage

```hcl
module "event_hub" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/messaging/event-hub?ref=v1.0.0"

  name                = "platform-eh"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Standard"
  capacity            = 2

  eventhubs = {
    telemetry = {
      partition_count   = 4
      message_retention = 3
    }
  }

  consumer_groups = {
    telemetry-processor = {
      eventhub_name = "telemetry"
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
| [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule) | resource |
| [azurerm_eventhub_consumer_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group) | resource |
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the Event Hubs namespace is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Event Hubs namespace. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Event Hubs namespace is created in. | `string` | n/a | yes |
| <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules) | Map of per-event-hub authorization rules to create, keyed by an arbitrary name. Each entry references the event hub it applies to via eventhub\_name. | <pre>map(object({<br/>    eventhub_name = string<br/>    listen        = optional(bool, true)<br/>    send          = optional(bool, false)<br/>    manage        = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_auto_inflate_enabled"></a> [auto\_inflate\_enabled](#input\_auto\_inflate\_enabled) | Whether auto-inflate of throughput units is enabled. Not supported on Dedicated. | `bool` | `false` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Throughput units (Basic/Standard) or processing units (Premium) provisioned for the namespace. | `number` | `1` | no |
| <a name="input_consumer_groups"></a> [consumer\_groups](#input\_consumer\_groups) | Map of consumer groups to create, keyed by an arbitrary name. Each entry references the event hub it belongs to via eventhub\_name. | <pre>map(object({<br/>    eventhub_name = string<br/>    user_metadata = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_eventhubs"></a> [eventhubs](#input\_eventhubs) | Map of event hubs to create within the namespace, keyed by event hub name. | <pre>map(object({<br/>    partition_count   = optional(number, 2)<br/>    message_retention = optional(number, 1)<br/>    capture_description = optional(object({<br/>      enabled             = optional(bool, true)<br/>      encoding            = optional(string, "Avro")<br/>      interval_in_seconds = optional(number, 300)<br/>      size_limit_in_bytes = optional(number, 314572800)<br/>      skip_empty_archives = optional(bool, true)<br/>      storage_account_id  = string<br/>      blob_container_name = string<br/>      archive_name_format = optional(string, "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}")<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Managed identity configuration for the namespace. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_maximum_throughput_units"></a> [maximum\_throughput\_units](#input\_maximum\_throughput\_units) | Maximum number of throughput units the namespace auto-inflates to. Required when auto\_inflate\_enabled is true, between 1 and 20. | `number` | `null` | no |
| <a name="input_network_rulesets"></a> [network\_rulesets](#input\_network\_rulesets) | Network rule set restricting access to the namespace. | <pre>object({<br/>    default_action                 = optional(string, "Deny")<br/>    trusted_service_access_enabled = optional(bool, false)<br/>    ip_rule = optional(list(object({<br/>      ip_mask = string<br/>      action  = optional(string, "Allow")<br/>    })), [])<br/>    virtual_network_rule = optional(list(object({<br/>      subnet_id                                       = string<br/>      ignore_missing_virtual_network_service_endpoint = optional(bool, false)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the namespace is enabled. Disabled by default; use private endpoints or network\_rulesets for controlled access. | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Pricing tier of the Event Hubs namespace. | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Whether availability zones are enabled for the namespace. | `bool` | `false` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_consumer_group_ids"></a> [consumer\_group\_ids](#output\_consumer\_group\_ids) | Map of consumer group name to consumer group ID. |
| <a name="output_eventhub_ids"></a> [eventhub\_ids](#output\_eventhub\_ids) | Map of event hub name to event hub ID. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the namespace managed identity, when identity is enabled. |
| <a name="output_namespace_id"></a> [namespace\_id](#output\_namespace\_id) | ID of the Event Hubs namespace. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | Map of authorization rule name to its primary connection string. |
<!-- END_TF_DOCS -->
