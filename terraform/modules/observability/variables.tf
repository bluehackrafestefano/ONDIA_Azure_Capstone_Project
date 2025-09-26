# Resource Group
variable "rg_name" {
  description = "Name of the resource group where observability resources will be deployed"
  type        = string
}

# Location
variable "location" {
  description = "Azure region for deployment"
  type        = string
}

# VM Scale Set ID
variable "vmss_id" {
  description = "Resource ID of the VM Scale Set for Grafana"
  type        = string
}

# Load Balancer ID
variable "lb_id" {
  description = "Resource ID of the Azure Load Balancer"
  type        = string
}

# PostgreSQL Flexible Server ID
variable "db_id" {
  description = "Resource ID of the PostgreSQL Flexible Server"
  type        = string
}

# Action Group ID (for alerts)
variable "action_group_id" {
  description = "Azure Monitor Action Group ID used for alert notifications"
  type        = string
}
