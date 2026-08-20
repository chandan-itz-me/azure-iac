locals {
  identity_type = length(var.user_assigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" : "SystemAssigned"
}

resource "azurerm_mssql_server" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type         = local.identity_type
    identity_ids = length(var.user_assigned_identity_ids) > 0 ? var.user_assigned_identity_ids : null
  }

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator != null ? [var.azuread_administrator] : []

    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_mssql_database" "this" {
  for_each = var.databases

  name                        = each.key
  server_id                   = azurerm_mssql_server.this.id
  sku_name                    = each.value.sku_name
  max_size_gb                 = each.value.max_size_gb
  zone_redundant              = each.value.zone_redundant
  create_mode                 = each.value.create_mode
  creation_source_database_id = each.value.creation_source_database_id

  short_term_retention_policy {
    retention_days = each.value.short_term_retention_days
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention != null ? [each.value.long_term_retention] : []

    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  tags = merge(var.tags, { Name = each.key })
}

resource "azurerm_mssql_firewall_rule" "this" {
  for_each = var.firewall_rules

  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_virtual_network_rule" "this" {
  for_each = var.virtual_network_rules

  name      = each.key
  server_id = azurerm_mssql_server.this.id
  subnet_id = each.value.subnet_id
}

resource "azurerm_mssql_server_transparent_data_encryption" "this" {
  count = var.transparent_data_encryption.key_vault_key_id != null ? 1 : 0

  server_id             = azurerm_mssql_server.this.id
  key_vault_key_id      = var.transparent_data_encryption.key_vault_key_id
  auto_rotation_enabled = var.transparent_data_encryption.auto_rotation_enabled
}

resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  count = var.auditing.blob_storage_endpoint != null ? 1 : 0

  server_id                               = azurerm_mssql_server.this.id
  storage_endpoint                        = var.auditing.blob_storage_endpoint
  storage_account_access_key              = var.auditing_storage_account_access_key
  storage_account_access_key_is_secondary = var.auditing.storage_account_access_key_is_secondary
  retention_in_days                       = var.auditing.retention_in_days
}

resource "azurerm_mssql_database_extended_auditing_policy" "this" {
  for_each = var.auditing.blob_storage_endpoint != null && var.auditing.database_auditing_enabled ? var.databases : {}

  database_id                             = azurerm_mssql_database.this[each.key].id
  storage_endpoint                        = var.auditing.blob_storage_endpoint
  storage_account_access_key              = var.auditing_storage_account_access_key
  storage_account_access_key_is_secondary = var.auditing.storage_account_access_key_is_secondary
  retention_in_days                       = var.auditing.retention_in_days
}
