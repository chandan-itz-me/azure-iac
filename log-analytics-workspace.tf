# -----------------------------------------------------------------------------
# Log Analytics workspace
# -----------------------------------------------------------------------------

module "log_analytics_workspace" {
  source = "./modules/observability/log-analytics-workspace"

  name                = var.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
}
