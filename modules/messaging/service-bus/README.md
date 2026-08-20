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
<!-- END_TF_DOCS -->
