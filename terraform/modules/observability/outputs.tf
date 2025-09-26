# Log Analytics Workspace ID
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.logs.id
}

# VMSS Diagnostic Setting ID
output "vmss_diagnostics_id" {
  description = "ID of the VMSS diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.vmss_diagnostics.id
}

# Load Balancer Diagnostic Setting ID
output "lb_diagnostics_id" {
  description = "ID of the Load Balancer diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.lb_diagnostics.id
}

# Database Diagnostic Setting ID
output "db_diagnostics_id" {
  description = "ID of the PostgreSQL Flexible Server diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.db_diagnostics.id
}

# VMSS CPU Alert Rule ID
output "vmss_cpu_alert_id" {
  description = "ID of the VMSS CPU alert rule"
  value       = azurerm_monitor_metric_alert.vmss_cpu_alert.id
}
