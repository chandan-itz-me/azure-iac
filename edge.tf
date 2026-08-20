# -----------------------------------------------------------------------------
# Edge and API resources
# -----------------------------------------------------------------------------

module "application_gateways" {
  for_each = var.application_gateways
  source   = "./modules/networking-edge/application-gateway"

  name                  = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name   = azurerm_resource_group.this.name
  location              = azurerm_resource_group.this.location
  subnet_id             = try(each.value.subnet_id, values(module.subnets.subnet_ids)[0])
  backend_address_pools = each.value.backend_address_pools
  backend_http_settings = each.value.backend_http_settings
  http_listeners        = each.value.http_listeners
  request_routing_rules = each.value.request_routing_rules
  identity_ids          = [for key in try(each.value.managed_identity_keys, []) : local.managed_identity_ids[key]]
  tags                  = local.common_tags
}

module "front_doors" {
  for_each = var.front_doors
  source   = "./modules/networking-edge/front-door"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  endpoint_name       = try(each.value.endpoint_name, "${var.project_name}-${each.key}")
  origin_groups       = each.value.origin_groups
  origins             = each.value.origins
  routes              = each.value.routes
  tags                = local.common_tags
}

module "api_managements" {
  for_each = var.api_managements
  source   = "./modules/networking-edge/api-management"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  publisher_name      = each.value.publisher_name
  publisher_email     = each.value.publisher_email
  identity_type       = try(each.value.identity_type, "SystemAssigned")
  identity_ids        = [for key in try(each.value.managed_identity_keys, []) : local.managed_identity_ids[key]]
  tags                = local.common_tags
}
