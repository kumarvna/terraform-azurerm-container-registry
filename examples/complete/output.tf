output "georeplications" {
  value = module.container-registry.georeplications
}

output "private_endpoint_custom_dns_records" {
  value = module.container-registry.private_endpoint_custom_dns_records
}

output "private_endpoint_custom_dns_records_ip" {
  value = module.container-registry.private_endpoint_custom_dns_records_ip
}

output "private_endpoint_custom_dns_config" {
  value = module.container-registry.private_endpoint_custom_dns_config
}
