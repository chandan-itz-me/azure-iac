resource "azurerm_eventhub_namespace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  capacity            = var.sku == "Dedicated" ? null : var.capacity

  auto_inflate_enabled     = var.sku == "Dedicated" ? false : var.auto_inflate_enabled
  maximum_throughput_units = var.auto_inflate_enabled ? var.maximum_throughput_units : null
  zone_redundant           = var.zone_redundant

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_rulesets" {
    for_each = var.network_rulesets != null ? [var.network_rulesets] : []

    content {
      default_action                 = network_rulesets.value.default_action
      trusted_service_access_enabled = network_rulesets.value.trusted_service_access_enabled

      dynamic "ip_rule" {
        for_each = network_rulesets.value.ip_rule

        content {
          ip_mask = ip_rule.value.ip_mask
          action  = ip_rule.value.action
        }
      }

      dynamic "virtual_network_rule" {
        for_each = network_rulesets.value.virtual_network_rule

        content {
          subnet_id                                       = virtual_network_rule.value.subnet_id
          ignore_missing_virtual_network_service_endpoint = virtual_network_rule.value.ignore_missing_virtual_network_service_endpoint
        }
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_eventhub" "this" {
  for_each = var.eventhubs

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.resource_group_name

  partition_count   = each.value.partition_count
  message_retention = each.value.message_retention

  dynamic "capture_description" {
    for_each = each.value.capture_description != null ? [each.value.capture_description] : []

    content {
      enabled             = capture_description.value.enabled
      encoding            = capture_description.value.encoding
      interval_in_seconds = capture_description.value.interval_in_seconds
      size_limit_in_bytes = capture_description.value.size_limit_in_bytes
      skip_empty_archives = capture_description.value.skip_empty_archives

      destination {
        name                = "EventHubArchive.AzureBlockBlob"
        archive_name_format = capture_description.value.archive_name_format
        blob_container_name = capture_description.value.blob_container_name
        storage_account_id  = capture_description.value.storage_account_id
      }
    }
  }
}

resource "azurerm_eventhub_consumer_group" "this" {
  for_each = var.consumer_groups

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this[each.value.eventhub_name].name
  resource_group_name = var.resource_group_name
  user_metadata       = each.value.user_metadata
}

resource "azurerm_eventhub_authorization_rule" "this" {
  for_each = var.authorization_rules

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this[each.value.eventhub_name].name
  resource_group_name = var.resource_group_name

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}
