output "resource_group" {
  description = "Name of the Resource Group"
  value       = var.rg_name
}

output "location" {
  description = "Azure region used for deployment"
  value       = var.location
}

output "grafana_url" {
  description = "Public URL for Grafana service"
  value       = module.compute.grafana_url
}
