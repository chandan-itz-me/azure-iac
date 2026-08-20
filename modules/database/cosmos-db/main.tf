locals {
  kind = var.api == "MongoDB" ? "MongoDB" : "GlobalDocumentDB"

  capability_name = {
    Cassandra = "EnableCassandra"
    Gremlin   = "EnableGremlin"
    Table     = "EnableTable"
  }

  sql_containers = merge([
    for db_key, db in var.sql_databases : {
      for c_key, c in db.containers : "${db_key}/${c_key}" => merge(c, {
        database_key  = db_key
        container_key = c_key
      })
    }
  ]...)
}

resource "azurerm_cosmosdb_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = var.offer_type
  kind                = local.kind

  public_network_access_enabled    = var.public_network_access_enabled
  automatic_failover_enabled       = var.automatic_failover_enabled
  multiple_write_locations_enabled = var.multiple_write_locations_enabled

  is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  consistency_policy {
    consistency_level       = var.consistency_policy.consistency_level
    max_interval_in_seconds = var.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy.max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = var.geo_locations

    content {
      location          = geo_location.key
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rules

    content {
      id                                   = virtual_network_rule.value.subnet_id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "capabilities" {
    for_each = contains(keys(local.capability_name), var.api) ? [local.capability_name[var.api]] : []

    content {
      name = capabilities.value
    }
  }

  backup {
    type                = var.backup.type
    interval_in_minutes = var.backup.type == "Periodic" ? var.backup.interval_in_minutes : null
    retention_in_hours  = var.backup.type == "Periodic" ? var.backup.retention_in_hours : null
    storage_redundancy  = var.backup.type == "Periodic" ? var.backup.storage_redundancy : null
    tier                = var.backup.type == "Continuous" ? var.backup.tier : null
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_cosmosdb_sql_database" "this" {
  for_each = var.sql_databases

  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = each.value.autoscale_max_throughput == null ? each.value.throughput : null

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_max_throughput != null ? [each.value.autoscale_max_throughput] : []

    content {
      max_throughput = autoscale_settings.value
    }
  }
}

resource "azurerm_cosmosdb_sql_container" "this" {
  for_each = local.sql_containers

  name                = each.value.container_key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this[each.value.database_key].name
  partition_key_paths = [each.value.partition_key_path]
  throughput          = each.value.autoscale_max_throughput == null ? each.value.throughput : null

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_max_throughput != null ? [each.value.autoscale_max_throughput] : []

    content {
      max_throughput = autoscale_settings.value
    }
  }

  dynamic "indexing_policy" {
    for_each = each.value.indexing_policy != null ? [each.value.indexing_policy] : []

    content {
      indexing_mode = indexing_policy.value.indexing_mode

      dynamic "included_path" {
        for_each = indexing_policy.value.included_paths

        content {
          path = included_path.value
        }
      }

      dynamic "excluded_path" {
        for_each = indexing_policy.value.excluded_paths

        content {
          path = excluded_path.value
        }
      }
    }
  }

  dynamic "unique_key" {
    for_each = each.value.unique_keys

    content {
      paths = unique_key.value
    }
  }
}
