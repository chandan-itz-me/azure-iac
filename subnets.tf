# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------

module "subnets" {
  source = "./modules/networking/subnet"

  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = module.vnet.vnet_name
  subnets              = var.subnets
}
