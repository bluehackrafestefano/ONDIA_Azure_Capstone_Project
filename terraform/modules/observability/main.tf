# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.rg_name}-logs"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Diagnostic Setting for VMSS
resource "azurerm_monitor_diagnostic_setting" "vmss_diagnostics" {
  name                       = "vmss-diagnostics"
  target_resource_id         = var.vmss_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  enabled_log {
    category = "VMSSAgentEvents"
  }

  enabled_log {
    category = "VMSSConsoleLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Setting for Load Balancer
resource "azurerm_monitor_diagnostic_setting" "lb_diagnostics" {
  name                       = "lb-diagnostics"
  target_resource_id         = var.lb_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  enabled_log {
    category = "LoadBalancerAlertEvent"
  }

  enabled_log {
    category = "LoadBalancerProbeHealthStatus"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Setting for PostgreSQL Flexible Server
resource "azurerm_monitor_diagnostic_setting" "db_diagnostics" {
  name                       = "db-diagnostics"
  target_resource_id         = var.db_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  enabled_log {
    category = "PostgreSQLQueryStoreRuntimeStatistics"
  }

  enabled_log {
    category = "PostgreSQLQueryStoreWaitStatistics"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Example Alert Rule for high CPU on VMSS
resource "azurerm_monitor_metric_alert" "vmss_cpu_alert" {
  name                = "vmss-high-cpu"
  resource_group_name = var.rg_name
  scopes              = [var.vmss_id]
  description         = "Alert when average CPU usage > 80% for 5 minutes"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size = "PT5M"
  frequency   = "PT1M"

  action {
    action_group_id = var.action_group_id
  }
}
