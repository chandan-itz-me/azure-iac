# messaging/event-grid

Creates either an Event Grid custom topic or an Event Grid domain (for
publishing many topics under a single resource), toggled with
`create_domain`, along with any number of event subscriptions targeting
webhooks, Event Hubs, Service Bus queues/topics, Storage queues or Azure
Functions.

## Usage

```hcl
module "event_grid" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/messaging/event-grid?ref=v1.0.0"

  name                = "platform-events"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  event_subscriptions = {
    to-webhook = {
      endpoint_type         = "webhook"
      webhook_endpoint_url  = "https://example.com/webhook"
      included_event_types  = ["Microsoft.Storage.BlobCreated"]
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
| [azurerm_eventgrid_domain.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_domain) | resource |
| [azurerm_eventgrid_event_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_event_subscription) | resource |
| [azurerm_eventgrid_topic.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the Event Grid resource is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Event Grid topic or domain. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the Event Grid resource is created in. | `string` | n/a | yes |
| <a name="input_create_domain"></a> [create\_domain](#input\_create\_domain) | Whether to create an Event Grid domain (for many topics) instead of a single custom topic. | `bool` | `false` | no |
| <a name="input_event_subscriptions"></a> [event\_subscriptions](#input\_event\_subscriptions) | Map of event subscriptions to create against the topic or domain, keyed by subscription name. | <pre>map(object({<br/>    endpoint_type = string<br/><br/>    webhook_endpoint_url = optional(string, null)<br/>    eventhub_id          = optional(string, null)<br/>    servicebus_queue_id  = optional(string, null)<br/>    servicebus_topic_id  = optional(string, null)<br/>    azure_function_id    = optional(string, null)<br/>    storage_queue = optional(object({<br/>      storage_account_id = string<br/>      queue_name         = string<br/>    }), null)<br/><br/>    included_event_types = optional(list(string), null)<br/><br/>    subject_filter = optional(object({<br/>      subject_begins_with = optional(string, null)<br/>      subject_ends_with   = optional(string, null)<br/>      case_sensitive      = optional(bool, false)<br/>    }), null)<br/><br/>    dead_letter_storage_blob = optional(object({<br/>      storage_account_id          = string<br/>      storage_blob_container_name = string<br/>    }), null)<br/><br/>    retry_policy = optional(object({<br/>      max_delivery_attempts         = optional(number, 30)<br/>      event_time_to_live_in_minutes = optional(number, 1440)<br/>    }), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Managed identity configuration for the topic or domain. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_input_schema"></a> [input\_schema](#input\_input\_schema) | Schema in which events are published to the topic or domain. | `string` | `"EventGridSchema"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access to the topic or domain is enabled. Disabled by default; use private endpoints for access instead. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | ID of the Event Grid domain, when create\_domain is true. |
| <a name="output_event_subscription_ids"></a> [event\_subscription\_ids](#output\_event\_subscription\_ids) | Map of event subscription name to its ID. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the topic or domain managed identity, when identity is enabled. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | Primary access key of the Event Grid topic or domain. |
| <a name="output_topic_endpoint"></a> [topic\_endpoint](#output\_topic\_endpoint) | Endpoint of the Event Grid topic or domain used to publish events. |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | ID of the Event Grid custom topic, when create\_domain is false. |
<!-- END_TF_DOCS -->
