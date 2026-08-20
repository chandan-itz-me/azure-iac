resource "azurerm_eventgrid_topic" "this" {
  count = var.create_domain ? 0 : 1

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  input_schema                  = var.input_schema
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_eventgrid_domain" "this" {
  count = var.create_domain ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  input_schema                  = var.input_schema
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_eventgrid_event_subscription" "this" {
  for_each = var.event_subscriptions

  name  = each.key
  scope = var.create_domain ? azurerm_eventgrid_domain.this[0].id : azurerm_eventgrid_topic.this[0].id

  included_event_types = each.value.included_event_types

  dynamic "webhook_endpoint" {
    for_each = each.value.endpoint_type == "webhook" ? [1] : []

    content {
      url = each.value.webhook_endpoint_url
    }
  }

  eventhub_endpoint_id          = each.value.endpoint_type == "eventhub" ? each.value.eventhub_id : null
  service_bus_queue_endpoint_id = each.value.endpoint_type == "servicebus_queue" ? each.value.servicebus_queue_id : null
  service_bus_topic_endpoint_id = each.value.endpoint_type == "servicebus_topic" ? each.value.servicebus_topic_id : null

  dynamic "storage_queue_endpoint" {
    for_each = each.value.endpoint_type == "storage_queue" ? [each.value.storage_queue] : []

    content {
      storage_account_id = storage_queue_endpoint.value.storage_account_id
      queue_name         = storage_queue_endpoint.value.queue_name
    }
  }

  dynamic "azure_function_endpoint" {
    for_each = each.value.endpoint_type == "azure_function" ? [1] : []

    content {
      function_id = each.value.azure_function_id
    }
  }

  dynamic "subject_filter" {
    for_each = each.value.subject_filter != null ? [each.value.subject_filter] : []

    content {
      subject_begins_with = subject_filter.value.subject_begins_with
      subject_ends_with   = subject_filter.value.subject_ends_with
      case_sensitive      = subject_filter.value.case_sensitive
    }
  }

  dynamic "storage_blob_dead_letter_destination" {
    for_each = each.value.dead_letter_storage_blob != null ? [each.value.dead_letter_storage_blob] : []

    content {
      storage_account_id          = storage_blob_dead_letter_destination.value.storage_account_id
      storage_blob_container_name = storage_blob_dead_letter_destination.value.storage_blob_container_name
    }
  }

  dynamic "retry_policy" {
    for_each = each.value.retry_policy != null ? [each.value.retry_policy] : []

    content {
      max_delivery_attempts = retry_policy.value.max_delivery_attempts
      event_time_to_live    = retry_policy.value.event_time_to_live_in_minutes
    }
  }
}
