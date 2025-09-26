output "vmss_id" {
  description = "ID of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "lb_id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.grafana_lb.id
}

output "grafana_url" {
  description = "Public URL for Grafana service"
  value       = "http://${azurerm_dns_a_record.grafana_dns.fqdn}"
}
