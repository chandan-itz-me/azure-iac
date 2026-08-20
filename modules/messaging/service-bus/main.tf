locals {
  subscriptions = merge([
    for topic_key, topic in var.topics : {
      for sub_key, sub in topic.subscriptions :
      "${topic_key}.${sub_key}" => merge(sub, { topic_key = topic_key, sub_key = sub_key })
    }
  ]...)

  subscription_rules = merge([
    for sub_full_key, sub in local.subscriptions : {
      for rule_key, rule in sub.rules :
      "${sub_full_key}.${rule_key}" => merge(rule, { sub_full_key = sub_full_key })
    }
  ]...)
}

resource "azurerm_servicebus_namespace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  capacity            = var.sku == "Premium" ? var.capacity : null
  zone_redundant      = var.sku == "Premium" ? var.zone_redundant : false

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" && var.network_rule_set != null ? [var.network_rule_set] : []

    content {
      default_action           = network_rule_set.value.default_action
      trusted_services_allowed = network_rule_set.value.trusted_services_allowed
      ip_rules                 = network_rule_set.value.ip_rules

      dynamic "network_rules" {
        for_each = network_rule_set.value.virtual_network_rules

        content {
          subnet_id                            = network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = network_rules.value.ignore_missing_virtual_network_service_endpoint
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

resource "azurerm_servicebus_namespace_disaster_recovery_config" "this" {
  count = var.enable_disaster_recovery_config ? 1 : 0

  name                 = var.disaster_recovery_alias_name
  primary_namespace_id = azurerm_servicebus_namespace.this.id
  partner_namespace_id = var.disaster_recovery_partner_namespace_id
}

resource "azurerm_servicebus_queue" "this" {
  for_each = var.queues

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id

  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  default_message_ttl                     = each.value.default_message_ttl
  lock_duration                           = each.value.lock_duration
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  requires_session                        = each.value.requires_session
  enable_partitioning                     = each.value.enable_partitioning
  max_delivery_count                      = each.value.max_delivery_count
}

resource "azurerm_servicebus_topic" "this" {
  for_each = var.topics

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id

  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  default_message_ttl                     = each.value.default_message_ttl
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  enable_partitioning                     = each.value.enable_partitioning
}

resource "azurerm_servicebus_subscription" "this" {
  for_each = local.subscriptions

  name     = each.value.sub_key
  topic_id = azurerm_servicebus_topic.this[each.value.topic_key].id

  max_delivery_count                   = each.value.max_delivery_count
  lock_duration                        = each.value.lock_duration
  default_message_ttl                  = each.value.default_message_ttl
  dead_lettering_on_message_expiration = each.value.dead_lettering_on_message_expiration
  requires_session                     = each.value.requires_session
  forward_to                           = each.value.forward_to
}

resource "azurerm_servicebus_subscription_rule" "this" {
  for_each = local.subscription_rules

  name            = split(".", each.key)[2]
  subscription_id = azurerm_servicebus_subscription.this[each.value.sub_full_key].id
  filter_type     = each.value.filter_type
  sql_filter      = each.value.filter_type == "SqlFilter" ? each.value.sql_filter : null

  dynamic "correlation_filter" {
    for_each = each.value.filter_type == "CorrelationFilter" && each.value.correlation_filter != null ? [each.value.correlation_filter] : []

    content {
      correlation_id = correlation_filter.value.correlation_id
      label          = correlation_filter.value.label
      message_id     = correlation_filter.value.message_id
      reply_to       = correlation_filter.value.reply_to
      session_id     = correlation_filter.value.session_id
      to             = correlation_filter.value.to
    }
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "this" {
  for_each = var.authorization_rules

  name         = each.key
  namespace_id = azurerm_servicebus_namespace.this.id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}
