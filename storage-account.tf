# -----------------------------------------------------------------------------
# Application storage account
# -----------------------------------------------------------------------------

module "storage_account" {
  source = "./modules/storage/storage-account"

  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}
