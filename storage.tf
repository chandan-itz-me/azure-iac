# -----------------------------------------------------------------------------
# Managed disks
# -----------------------------------------------------------------------------

module "managed_disks" {
  for_each = var.managed_disks
  source   = "./modules/storage/managed-disk"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}
