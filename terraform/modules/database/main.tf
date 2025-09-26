# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "${var.rg_name}-pg"
  resource_group_name    = var.rg_name
  location               = var.location
  version                = "17"
  delegated_subnet_id    = var.db_subnet_id
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name               = "Standard_B1ms"

  storage_mb              = 32768 # 32 GB
  backup_retention_days   = 7
  geo_redundant_backup_enabled = false

  # High availability disabled
  zone = "1"

  lifecycle {
    prevent_destroy = true
  }
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_database" "grafana_db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.db.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Firewall Rule (optional - for Azure services or Bastion)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
