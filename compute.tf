# -----------------------------------------------------------------------------
# Compute resources
# Configure each map in variables.tf to enable the corresponding module.
# -----------------------------------------------------------------------------

module "virtual_machines" {
  for_each = var.virtual_machines
  source   = "./modules/compute/virtual-machine"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = each.value.os_type
  size                = each.value.size
  admin_username      = each.value.admin_username
  subnet_id           = try(each.value.subnet_id, values(module.subnets.subnet_ids)[0])
  tags                = local.common_tags
}

module "vmss" {
  for_each = var.vmss
  source   = "./modules/compute/vmss"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = each.value.os_type
  sku                 = each.value.sku
  admin_username      = each.value.admin_username
  subnet_id           = try(each.value.subnet_id, values(module.subnets.subnet_ids)[0])
  tags                = local.common_tags
}

module "aks_clusters" {
  for_each = var.aks_clusters
  source   = "./modules/compute/aks-cluster"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  dns_prefix          = try(each.value.dns_prefix, "${var.project_name}-${each.key}")
  default_node_pool   = each.value.default_node_pool
  tags                = local.common_tags
}

module "container_apps" {
  for_each = var.container_apps
  source   = "./modules/compute/container-app"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  containers          = each.value.containers
  tags                = local.common_tags
}

module "app_services" {
  for_each = var.app_services
  source   = "./modules/compute/app-service"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = each.value.os_type
  tags                = local.common_tags
}
