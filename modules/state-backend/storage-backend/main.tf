locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
}

resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = local.resource_group_name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version

  public_network_access_enabled = var.public_network_access_enabled

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.allowed_ip_rules
  }

  dynamic "identity" {
    for_each = var.enable_customer_managed_key ? [1] : []

    content {
      type = "SystemAssigned"
    }
  }

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = var.delete_retention_days
    }
  }

  tags = merge(var.tags, { Name = var.storage_account_name })
}

resource "azurerm_storage_account_customer_managed_key" "this" {
  count = var.enable_customer_managed_key ? 1 : 0

  storage_account_id        = azurerm_storage_account.this.id
  key_vault_id              = var.customer_managed_key.key_vault_id
  key_name                  = var.customer_managed_key.key_name
  key_version               = var.customer_managed_key.key_version
  user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "this" {
  for_each = var.create_role_assignments ? { for principal_id in var.runner_principal_ids : principal_id => principal_id } : {}

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}
