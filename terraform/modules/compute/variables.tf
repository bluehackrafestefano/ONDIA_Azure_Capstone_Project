variable "rg_name" {
  description = "Resource Group for compute resources"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "app_subnet_id" {
  description = "Subnet ID where VMSS instances will run"
  type        = string
}

variable "ssh_public_key" {
  description = "Path to SSH public key for VM access"
  type        = string
}

variable "dns_zone_name" {
  description = "Azure DNS zone name"
  type        = string
}

variable "dns_rg_name" {
  description = "Resource Group containing DNS zone"
  type        = string
}

variable "db_connection" {
  description = "Database connection string for Grafana"
  type        = string
}
