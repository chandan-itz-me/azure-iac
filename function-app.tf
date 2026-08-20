# -----------------------------------------------------------------------------
# Function App
# -----------------------------------------------------------------------------

module "function_app" {
  source = "./modules/compute/function-app"

  name                       = var.function_app_name
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  os_type                    = var.function_app_os_type
  storage_account_name       = module.storage_account.name
  storage_account_access_key = module.storage_account.primary_access_key
  tags                       = local.common_tags
}
