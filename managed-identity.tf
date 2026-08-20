# -----------------------------------------------------------------------------
# Shared managed identity for core workloads
# -----------------------------------------------------------------------------

module "function_app_identity" {
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    function_app = {
      name = "${var.project_name}-${var.environment}-function-app"
    }
  }
  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Workload identities
#
# These identities are created only for configured workloads that use the default
# user-assigned identity mode. Set identity_type = "SystemAssigned" to use the
# platform-managed identity instead, or provide managed_identity_keys to attach a
# shared identity from module "managed_identities".
# -----------------------------------------------------------------------------

module "virtual_machine_identities" {
  for_each = {
    for key, value in var.virtual_machines : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-vm" }
  }
  tags = local.common_tags
}

module "vmss_identities" {
  for_each = {
    for key, value in var.vmss : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-vmss" }
  }
  tags = local.common_tags
}

module "aks_identities" {
  for_each = {
    for key, value in var.aks_clusters : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-aks" }
  }
  tags = local.common_tags
}

module "container_app_identities" {
  for_each = {
    for key, value in var.container_apps : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-container-app" }
  }
  tags = local.common_tags
}

module "app_service_identities" {
  for_each = {
    for key, value in var.app_services : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-app-service" }
  }
  tags = local.common_tags
}

module "cosmos_db_identities" {
  for_each = {
    for key, value in var.cosmos_dbs : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-cosmos" }
  }
  tags = local.common_tags
}

module "sql_identities" {
  for_each = {
    for key, value in var.sql_databases : key => value
    if length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-sql" }
  }
  tags = local.common_tags
}

module "service_bus_identities" {
  for_each = {
    for key, value in var.service_bus_namespaces : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-service-bus" }
  }
  tags = local.common_tags
}

module "event_grid_identities" {
  for_each = {
    for key, value in var.event_grids : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-event-grid" }
  }
  tags = local.common_tags
}

module "event_hub_identities" {
  for_each = {
    for key, value in var.event_hubs : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-event-hub" }
  }
  tags = local.common_tags
}

module "application_gateway_identities" {
  for_each = {
    for key, value in var.application_gateways : key => value
    if length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-app-gateway" }
  }
  tags = local.common_tags
}

module "api_management_identities" {
  for_each = {
    for key, value in var.api_managements : key => value
    if try(value.identity_type, "UserAssigned") == "UserAssigned" && length(try(value.managed_identity_keys, [])) == 0
  }
  source = "./modules/security/managed-identity"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  identities = {
    workload = { name = "${var.project_name}-${var.environment}-${each.key}-api-management" }
  }
  tags = local.common_tags
}
