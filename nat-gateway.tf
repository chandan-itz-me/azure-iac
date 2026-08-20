# -----------------------------------------------------------------------------
# NAT gateway
# -----------------------------------------------------------------------------

module "nat_gateway" {
  source = "./modules/networking/nat-gateway"

  name                = "${var.project_name}-${var.environment}-nat"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_ids = {
    for key in var.nat_gateway_subnet_keys : key => module.subnets.subnet_ids[key]
  }
  tags = local.common_tags
}
