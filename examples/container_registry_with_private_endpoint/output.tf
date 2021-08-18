
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = module.container-registry.resource_group_name
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = module.container-registry.resource_group_id
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = module.container-registry.resource_group_location
}

output "container_registry_id" {
  description = "The ID of the Container Registry"
  value       = module.container-registry.container_registry_id
}

output "container_registry_login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = module.container-registry.container_registry_login_server
}

output "container_registry_admin_username" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
  value       = module.container-registry.container_registry_admin_username
}

output "container_registry_admin_password" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
  value       = module.container-registry.container_registry_admin_password
  sensitive   = true
}

output "container_registry_identity_principal_id" {
  description = "The Principal ID for the Service Principal associated with the Managed Service Identity of this Container Registry"
  value       = module.container-registry.container_registry_identity_principal_id
}

output "container_registry_identity_tenant_id" {
  description = "The Tenant ID for the Service Principal associated with the Managed Service Identity of this Container Registry"
  value       = module.container-registry.container_registry_identity_tenant_id
}

output "container_registry_scope_map_id" {
  description = "The ID of the Container Registry scope map"
  value       = module.container-registry.container_registry_scope_map_id
}

output "container_registry_token_id" {
  description = "The ID of the Container Registry token"
  value       = module.container-registry.container_registry_token_id
}

output "container_registry_webhook_id" {
  description = "The ID of the Container Registry Webhook"
  value       = module.container-registry.container_registry_webhook_id
}

output "container_registry_private_endpoint" {
  description = "id of the Azure Container Registry Private Endpoint"
  value       = module.container-registry.container_registry_private_endpoint
}

output "container_registry_private_dns_zone_domain" {
  description = "DNS zone name of Azure Container Registry Private endpoints dns name records"
  value       = module.container-registry.container_registry_private_dns_zone_domain
}

output "container_registry_private_endpoint_ip_addresses" {
  description = "Azure Container Registry private endpoint IPv4 Addresses "
  value       = module.container-registry.container_registry_private_endpoint_ip_addresses
}

output "container_registry_private_endpoint_fqdn" {
  description = "Azure Container Registry private endpoint FQDN Addresses "
  value       = module.container-registry.container_registry_private_endpoint_fqdn
}
