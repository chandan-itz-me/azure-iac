locals {
  identity_type = var.customer_managed_key.enabled ? "SystemAssigned, UserAssigned" : "SystemAssigned"
}

resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  min_tls_version               = var.min_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  shared_access_key_enabled     = var.shared_access_key_enabled
  https_traffic_only_enabled    = var.https_traffic_only_enabled

  identity {
    type         = local.identity_type
    identity_ids = var.customer_managed_key.enabled ? [var.customer_managed_key.user_assigned_identity_id] : []
  }

  network_rules {
    default_action             = var.network_rules.default_action
    bypass                     = var.network_rules.bypass
    ip_rules                   = var.network_rules.ip_rules
    virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
  }

  blob_properties {
    versioning_enabled  = var.blob_properties.versioning_enabled
    change_feed_enabled = var.blob_properties.change_feed_enabled

    delete_retention_policy {
      days = var.blob_properties.delete_retention_days
    }

    container_delete_retention_policy {
      days = var.blob_properties.container_delete_retention_days
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_share" "this" {
  for_each = var.file_shares

  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota_gb
}

resource "azurerm_storage_queue" "this" {
  for_each = var.queues

  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_storage_table" "this" {
  for_each = var.tables

  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
}

# Requires the storage account identity to have Key Vault Crypto Service Encryption access.
resource "azurerm_storage_account_customer_managed_key" "this" {
  count = var.customer_managed_key.enabled ? 1 : 0

  storage_account_id        = azurerm_storage_account.this.id
  key_vault_id              = var.customer_managed_key.key_vault_id
  key_name                  = var.customer_managed_key.key_name
  key_version               = var.customer_managed_key.key_version
  user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
}

resource "azurerm_storage_management_policy" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  storage_account_id = azurerm_storage_account.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      name    = rule.key
      enabled = true

      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }

      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
      }
    }
  }
}
