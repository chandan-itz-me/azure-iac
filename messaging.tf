# -----------------------------------------------------------------------------
# Messaging resources
# -----------------------------------------------------------------------------

module "service_bus_namespaces" {
  for_each = var.service_bus_namespaces
  source   = "./modules/messaging/service-bus"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identity = {
    type         = try(each.value.identity_type, "SystemAssigned")
    identity_ids = [for key in try(each.value.managed_identity_keys, []) : local.managed_identity_ids[key]]
  }
  tags = local.common_tags
}

module "event_grids" {
  for_each = var.event_grids
  source   = "./modules/messaging/event-grid"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identity = {
    type         = try(each.value.identity_type, "SystemAssigned")
    identity_ids = [for key in try(each.value.managed_identity_keys, []) : local.managed_identity_ids[key]]
  }
  tags = local.common_tags
}

module "event_hubs" {
  for_each = var.event_hubs
  source   = "./modules/messaging/event-hub"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identity = {
    type         = try(each.value.identity_type, "SystemAssigned")
    identity_ids = [for key in try(each.value.managed_identity_keys, []) : local.managed_identity_ids[key]]
  }
  tags = local.common_tags
}
