# -----------------------------------------------------------------------------
# Database resources
# -----------------------------------------------------------------------------

module "cosmos_dbs" {
  for_each = var.cosmos_dbs
  source   = "./modules/database/cosmos-db"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  geo_locations       = each.value.geo_locations
  tags                = local.common_tags
}

module "sql_databases" {
  for_each = var.sql_databases
  source   = "./modules/database/azure-sql-database"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}

module "redis_caches" {
  for_each = var.redis_caches
  source   = "./modules/database/redis-cache"

  name                = try(each.value.name, "${var.project_name}-${each.key}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}
