# -----------------------------------------------------------------------------
# Messaging resources
# -----------------------------------------------------------------------------

module "service_bus_namespaces" {
  for_each = var.service_bus_namespaces
  source   = "./modules/messaging/service-bus"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identity = try(each.value.identity_type, "UserAssigned") == "UserAssigned" ? {
    type = "UserAssigned"
    identity_ids = length(try(each.value.managed_identity_keys, [])) > 0 ? [
      for key in each.value.managed_identity_keys : local.managed_identity_ids[key]
    ] : [module.service_bus_identities[each.key].identity_ids["workload"]]
    } : {
    type         = "SystemAssigned"
    identity_ids = []
  }
  tags = local.common_tags
}

module "event_grids" {
  for_each = var.event_grids
  source   = "./modules/messaging/event-grid"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identity = try(each.value.identity_type, "UserAssigned") == "UserAssigned" ? {
    type = "UserAssigned"
    identity_ids = length(try(each.value.managed_identity_keys, [])) > 0 ? [
      for key in each.value.managed_identity_keys : local.managed_identity_ids[key]
    ] : [module.event_grid_identities[each.key].identity_ids["workload"]]
    } : {
    type         = "SystemAssigned"
    identity_ids = []
  }
  tags = local.common_tags
}

module "event_hubs" {
  for_each = var.event_hubs
  source   = "./modules/messaging/event-hub"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identity = try(each.value.identity_type, "UserAssigned") == "UserAssigned" ? {
    type = "UserAssigned"
    identity_ids = length(try(each.value.managed_identity_keys, [])) > 0 ? [
      for key in each.value.managed_identity_keys : local.managed_identity_ids[key]
    ] : [module.event_hub_identities[each.key].identity_ids["workload"]]
    } : {
    type         = "SystemAssigned"
    identity_ids = []
  }
  tags = local.common_tags
}
