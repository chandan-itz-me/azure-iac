output "diagnostic_setting_ids" {
  description = "Map of diagnostic setting name to its resource ID."
  value       = { for k, v in azurerm_monitor_diagnostic_setting.this : k => v.id }
}
