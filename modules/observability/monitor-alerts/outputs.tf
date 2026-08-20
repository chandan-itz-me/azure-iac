output "metric_alert_ids" {
  description = "Map of metric alert name to its resource ID."
  value       = { for k, v in azurerm_monitor_metric_alert.this : k => v.id }
}

output "activity_log_alert_ids" {
  description = "Map of activity log alert name to its resource ID."
  value       = { for k, v in azurerm_monitor_activity_log_alert.this : k => v.id }
}

output "action_group_ids" {
  description = "Map of action group name to its resource ID."
  value       = { for k, v in azurerm_monitor_action_group.this : k => v.id }
}

output "scheduled_query_rule_ids" {
  description = "Map of scheduled query rule name to its resource ID."
  value       = { for k, v in azurerm_monitor_scheduled_query_rules_alert_v2.this : k => v.id }
}
