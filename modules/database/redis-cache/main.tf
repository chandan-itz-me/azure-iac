resource "azurerm_redis_cache" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name

  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  non_ssl_port_enabled          = false
  zones                         = length(var.zones) > 0 ? var.zones : null

  redis_configuration {
    maxmemory_policy                = var.redis_configuration.maxmemory_policy
    enable_authentication           = var.redis_configuration.enable_authentication
    rdb_backup_enabled              = var.redis_configuration.rdb_backup_enabled
    rdb_backup_frequency            = var.redis_configuration.rdb_backup_enabled ? var.redis_configuration.rdb_backup_frequency : null
    rdb_backup_max_snapshot_count   = var.redis_configuration.rdb_backup_enabled ? var.redis_configuration.rdb_backup_max_snapshot_count : null
    rdb_storage_connection_string   = var.redis_configuration.rdb_backup_enabled ? var.redis_configuration.rdb_storage_connection_string : null
    aof_backup_enabled              = var.redis_configuration.aof_backup_enabled
    aof_storage_connection_string_0 = var.redis_configuration.aof_backup_enabled ? var.redis_configuration.aof_storage_connection_string_0 : null
    aof_storage_connection_string_1 = var.redis_configuration.aof_backup_enabled ? var.redis_configuration.aof_storage_connection_string_1 : null
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedules

    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = patch_schedule.value.maintenance_window
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_redis_firewall_rule" "this" {
  for_each = var.firewall_rules

  name                = each.key
  redis_cache_name    = azurerm_redis_cache.this.name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}

resource "azurerm_redis_linked_server" "this" {
  for_each = var.linked_servers

  target_redis_cache_name     = azurerm_redis_cache.this.name
  resource_group_name         = var.resource_group_name
  linked_redis_cache_id       = each.value.linked_redis_cache_id
  linked_redis_cache_location = each.value.linked_redis_cache_location
  server_role                 = each.value.server_role
}
