output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "app_subnet_id" {
  description = "ID of the application subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db_subnet.id
}

output "bastion_id" {
  description = "ID of the Bastion Host"
  value       = azurerm_bastion_host.bastion.id
}
