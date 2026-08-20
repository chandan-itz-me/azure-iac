# -----------------------------------------------------------------------------
# Virtual network
# -----------------------------------------------------------------------------

module "vnet" {
  source = "./modules/networking/vnet"

  name                = "${var.project_name}-${var.environment}-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}
