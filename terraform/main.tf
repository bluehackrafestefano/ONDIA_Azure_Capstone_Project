provider "azurerm" {
  features {}
}

module "network" {
  source   = "./modules/network"
  rg_name  = var.rg_name
  location = var.location
}

module "database" {
  source        = "./modules/database"
  rg_name       = var.rg_name
  location      = var.location
  vnet_id       = module.network.vnet_id
  db_subnet_id  = module.network.db_subnet_id

  db_admin_username = var.db_admin_username
  db_admin_password = var.db_admin_password
}

module "compute" {
  source            = "./modules/compute"
  rg_name           = var.rg_name
  location          = var.location
  app_subnet_id     = module.network.app_subnet_id
  lb_public_ip_name = "grafana-lb-ip"
  db_connection     = module.database.db_connection

  dns_rg_name   = var.dns_rg_name
  dns_zone_name = var.dns_zone_name
  ssh_public_key = var.ssh_public_key
}

module "observability" {
  source          = "./modules/observability"
  rg_name         = var.rg_name
  location        = var.location
  vmss_id         = module.compute.vmss_id
  lb_id           = module.compute.lb_id
  db_id           = module.database.db_id
  action_group_id = var.action_group_id
}
