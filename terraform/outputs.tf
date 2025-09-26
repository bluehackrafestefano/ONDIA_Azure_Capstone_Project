output "gitlab_vm_public_ip" {
  description = "Public IP of the GitLab VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "postgresql_hostname" {
  description = "PostgreSQL Flexible Server FQDN"
  value       = azurerm_postgresql_flexible_server.pg.fqdn
}
