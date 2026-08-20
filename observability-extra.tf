# -----------------------------------------------------------------------------
# Observability resources
# -----------------------------------------------------------------------------

module "monitor_diagnostic_settings" {
  for_each = var.monitor_diagnostic_settings
  source   = "./modules/observability/monitor-diagnostic-settings"

  diagnostic_settings = each.value.diagnostic_settings
}

module "monitor_alerts" {
  for_each = var.monitor_alerts
  source   = "./modules/observability/monitor-alerts"

  resource_group_name = azurerm_resource_group.this.name
}
