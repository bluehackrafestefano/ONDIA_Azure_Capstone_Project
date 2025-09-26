variable "rg_name" {
  description = "Resource Group for observability resources"
  type        = string
}

variable "location" {
  description = "Azure region for observability deployment"
  type        = string
}

variable "vmss_id" {
  description = "ID of VMSS to monitor"
  type        = string
}

variable "lb_id" {
  description = "ID of Load Balancer to monitor"
  type        = string
}

variable "db_id" {
  description = "ID of PostgreSQL Flexible Server to monitor"
  type        = string
}

variable "action_group_id" {
  description = "Azure Monitor Action Group ID for alerts"
  type        = string
}
