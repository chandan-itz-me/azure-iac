resource "azurerm_disk_encryption_set" "this" {
  count = var.disk_encryption_set.enabled ? 1 : 0

  name                = "${var.name}-des"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = var.disk_encryption_set.key_vault_key_id

  identity {
    type         = var.disk_encryption_set.identity_type
    identity_ids = var.disk_encryption_set.identity_type == "UserAssigned" || var.disk_encryption_set.identity_type == "SystemAssigned, UserAssigned" ? var.disk_encryption_set.user_assigned_identity_ids : null
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "this" {
  for_each = var.disks

  name                   = each.key
  resource_group_name    = var.resource_group_name
  location               = var.location
  storage_account_type   = each.value.storage_account_type
  create_option          = each.value.create_option
  disk_size_gb           = each.value.disk_size_gb
  source_resource_id     = each.value.source_resource_id
  source_uri             = each.value.source_uri
  os_type                = each.value.os_type
  hyper_v_generation     = each.value.hyper_v_generation
  disk_encryption_set_id = each.value.disk_encryption_set_id != null ? each.value.disk_encryption_set_id : try(azurerm_disk_encryption_set.this[0].id, null)
  network_access_policy  = each.value.network_access_policy
  disk_access_id         = each.value.disk_access_id
  zone                   = each.value.zone

  tags = merge(var.tags, { Name = each.key })
}
