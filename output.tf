output "georeplications" {
  value = azurerm_container_registry.main.georeplications.*.location
}

output "private_endpoint_custom_dns_records" {
  value = flatten(azurerm_private_endpoint.pep1.0.custom_dns_configs.*.fqdn)
}

output "private_endpoint_custom_dns_records_ip" {
  value = flatten(azurerm_private_endpoint.pep1.0.custom_dns_configs.*.ip_addresses)
}

/* output "private_endpoint_custom_dns_config" {
  value = flatten(azurerm_private_endpoint.pep1.0.private_dns_zone_configs)
}
 */
output "private_endpoint_custom_dns_config_name" {
  value = flatten(azurerm_private_endpoint.pep1.0.custom_dns_configs.*.fqdn)
}

output "private_endpoint_custom_dns_config_ip" {
  value = flatten(azurerm_private_endpoint.pep1.0.custom_dns_configs.*.ip_addresses)
}
