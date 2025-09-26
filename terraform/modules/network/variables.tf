variable "rg_name" {
  description = "Resource Group name for networking resources"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

# Database Admin Username
variable "db_admin_username" {
  description = "Administrator username for the PostgreSQL Flexible Server"
  type        = string
}

# Database Admin Password
variable "db_admin_password" {
  description = "Administrator password for the PostgreSQL Flexible Server"
  type        = string
  sensitive   = true
}

# Action Group ID (for observability alerts)
variable "action_group_id" {
  description = "Azure Monitor Action Group ID used for alert notifications"
  type        = string
}

# DNS Zone Resource Group
variable "dns_rg_name" {
  description = "Resource group where the DNS zone is deployed"
  type        = string
}

# DNS Zone Name
variable "dns_zone_name" {
  description = "Azure DNS zone name (e.g., mydomain.com)"
  type        = string
}

# SSH Public Key
variable "ssh_public_key" {
  description = "Public SSH key for accessing Grafana VMSS instances"
  type        = string
}

# Action Group ID (for observability alerts)
variable "action_group_id" {
  description = "Azure Monitor Action Group ID used for alert notifications"
  type        = string
}
