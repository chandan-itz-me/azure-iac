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
<!-- END_TF_DOCS -->
