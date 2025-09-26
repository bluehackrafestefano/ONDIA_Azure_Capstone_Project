# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_ip" {
  name                = "${var.rg_name}-lb-ip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "grafana_lb" {
  name                = "${var.rg_name}-lb"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.grafana_lb.id
  name            = "BackEndAddressPool"
}

# Health probe
resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.grafana_lb.id
  name            = "http-probe"
  protocol        = "Tcp"
  port            = 3000 # Grafana default port
}

# Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.grafana_lb.id
  name                           = "grafana-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 3000
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}

# Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "${var.rg_name}-vmss"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard_B2s"
  instances           = 2
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.app_subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
    }
  }

  # Install Grafana via cloud-init
  custom_data = filebase64("${path.module}/cloud-init.yaml")
}

# DNS record for Grafana
resource "azurerm_dns_a_record" "grafana_dns" {
  name                = "grafana"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_rg_name
  ttl                 = 300
  records             = [azurerm_public_ip.lb_ip.ip_address]
}
