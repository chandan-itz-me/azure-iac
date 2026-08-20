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
<!-- END_TF_DOCS -->
