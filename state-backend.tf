# -----------------------------------------------------------------------------
# Remote state bootstrap
# Use this module from a separate bootstrap state before configuring the backend.
# -----------------------------------------------------------------------------

module "state_backends" {
  for_each = var.state_backends
  source   = "./modules/state-backend/storage-backend"

  resource_group_name  = try(each.value.resource_group_name, azurerm_resource_group.this.name)
  location             = azurerm_resource_group.this.location
  storage_account_name = each.value.storage_account_name
  tags                 = local.common_tags
}
