variable "rg_name" {
  description = "Resource Group for database resources"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "db_subnet_id" {
  description = "Subnet ID for PostgreSQL Flexible Server"
  type        = string
}

variable "db_admin_username" {
  description = "Admin username for PostgreSQL"
  type        = string
}

variable "db_admin_password" {
  description = "Admin password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name for Grafana"
  type        = string
  default     = "grafanadb"
}
