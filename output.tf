output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

output "container_registry_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.main.id
}

output "container_registry_login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_admin_username" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
  value       = var.container_registry_config.admin_enabled == true ? azurerm_container_registry.main.admin_username : null
}

output "container_registry_admin_password" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
  value       = var.container_registry_config.admin_enabled == true ? azurerm_container_registry.main.admin_password : null
  sensitive   = true
}

output "container_registry_identity_principal_id" {
  description = "The Principal ID for the Service Principal associated with the Managed Service Identity of this Container Registry"
  value       = flatten(azurerm_container_registry.main.identity.*.principal_id)
}

output "container_registry_identity_tenant_id" {
  description = "The Tenant ID for the Service Principal associated with the Managed Service Identity of this Container Registry"
  value       = flatten(azurerm_container_registry.main.identity.*.tenant_id)
}

output "container_registry_scope_map_id" {
  description = "The ID of the Container Registry scope map"
  value       = var.scope_map != null ? [for k in azurerm_container_registry_scope_map.main : k.id] : null
}

output "container_registry_token_id" {
  description = "The ID of the Container Registry token"
  value       = var.scope_map != null ? [for k in azurerm_container_registry_token.main : k.id] : null
}

output "container_registry_webhook_id" {
  description = "The ID of the Container Registry Webhook"
  value       = var.container_registry_webhooks != null ? [for k in azurerm_container_registry_webhook.main : k.id] : null
}

output "container_registry_private_endpoint" {
  description = "The ID of the Azure Container Registry Private Endpoint"
  value       = var.enable_private_endpoint ? element(concat(azurerm_private_endpoint.pep1.*.id, [""]), 0) : null
}

output "container_registry_private_dns_zone_domain" {
  description = "DNS zone name of Azure Container Registry Private endpoints dns name records"
  value       = var.existing_private_dns_zone == null && var.enable_private_endpoint ? element(concat(azurerm_private_dns_zone.dnszone1.*.name, [""]), 0) : var.existing_private_dns_zone
}

output "container_registry_private_endpoint_ip_addresses" {
  description = "Azure Container Registry private endpoint IPv4 Addresses"
  value       = var.enable_private_endpoint ? flatten(azurerm_private_endpoint.pep1.0.custom_dns_configs.*.ip_addresses) : null
}

output "container_registry_private_endpoint_fqdn" {
  description = "Azure Container Registry private endpoint FQDN Addresses"
  value       = var.enable_private_endpoint ? flatten(azurerm_private_endpoint.pep1.0.custom_dns_configs.*.fqdn) : null
}
