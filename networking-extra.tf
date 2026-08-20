# -----------------------------------------------------------------------------
# Additional networking resources
# -----------------------------------------------------------------------------

module "network_security_groups" {
  for_each = var.network_security_groups
  source   = "./modules/networking/network-security-group"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}

module "private_dns_zones" {
  for_each = var.private_dns_zones
  source   = "./modules/networking/private-dns-zone"

  name                = try(each.value.name, "${each.key}.internal")
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.common_tags
}

module "vnet_peerings" {
  for_each = var.vnet_peerings
  source   = "./modules/networking/vnet-peering"

  name                      = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = module.vnet.vnet_name
  virtual_network_id        = module.vnet.vnet_id
  remote_virtual_network_id = each.value.remote_virtual_network_id
}

module "private_endpoints" {
  for_each = var.private_endpoints
  source   = "./modules/networking/private-endpoint"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = try(each.value.subnet_id, values(module.subnets.subnet_ids)[0])
  tags                = local.common_tags
}

module "vnet_gateways" {
  for_each = var.vnet_gateways
  source   = "./modules/networking/vnet-gateway"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = try(each.value.subnet_id, values(module.subnets.subnet_ids)[0])
  tags                = local.common_tags
}
