#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

#---------------------------------------------------------
# Container Registry Resoruce - Default is "true"
#----------------------------------------------------------

resource "azurerm_container_registry" "main" {
  name                          = format("%s", var.container_registry_config.name)
  resource_group_name           = local.resource_group_name
  location                      = local.location
  admin_enabled                 = var.container_registry_config.admin_enabled
  sku                           = var.container_registry_config.sku
  public_network_access_enabled = var.container_registry_config.public_network_access_enabled
  quarantine_policy_enabled     = var.container_registry_config.quarantine_policy_enabled
  zone_redundancy_enabled       = var.container_registry_config.zone_redundancy_enabled
  tags                          = merge({ "Name" = format("%s", var.container_registry_config.name) }, var.tags, )

  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = merge({ "Name" = format("%s", "georep-${georeplications.value.location}") }, var.tags, )
    }
  }

  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action = lookup(network_rule_set.value, "default_action", "Allow")

      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rule
        content {
          action   = "Allow"
          ip_range = ip_rule.value.ip_range
        }
      }

      dynamic "virtual_network" {
        for_each = network_rule_set.value.virtual_network
        content {
          action    = "Allow"
          subnet_id = virtual_network.value.subnet_id
        }
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : []
    content {
      days    = lookup(retention_policy.value, "days", 7)
      enabled = lookup(retention_policy.value, "enabled", true)
    }
  }

  dynamic "trust_policy" {
    for_each = var.enable_content_trust ? [1] : []
    content {
      enabled = var.enable_content_trust
    }
  }

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : []
    content {
      enabled            = true
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }
}

#------------------------------------------------------------
# Container Registry Resoruce Scope map - Default is "false"
#------------------------------------------------------------

resource "azurerm_container_registry_scope_map" "main" {
  count                   = var.scope_map != null ? 1 : 0
  name                    = format("%s", var.scope_map.name)
  resource_group_name     = local.resource_group_name
  container_registry_name = azurerm_container_registry.main.name
  actions                 = var.scope_map.actions
}

#------------------------------------------------------------
# Container Registry Token  - Default is "false"
#------------------------------------------------------------
resource "azurerm_container_registry_token" "main" {
  count                   = var.scope_map != null && var.create_container_registry_token ? 1 : 0
  name                    = format("%s", "${var.container_registry_config.name}-token")
  resource_group_name     = local.resource_group_name
  container_registry_name = azurerm_container_registry.main.name
  scope_map_id            = azurerm_container_registry_scope_map.main.0.id
  enabled                 = var.create_container_registry_token
}

#------------------------------------------------------------
# Container Registry webhook - Default is "true"
#------------------------------------------------------------
resource "azurerm_container_registry_webhook" "main" {
  count               = var.container_registry_webhook != null ? 1 : 0
  name                = format("%s", "${var.container_registry_config.name}webhook")
  resource_group_name = local.resource_group_name
  location            = local.location
  registry_name       = azurerm_container_registry.main.name
  service_uri         = var.container_registry_webhook.service_uri
  actions             = var.container_registry_webhook.actions
  status              = var.container_registry_webhook.status
  scope               = var.container_registry_webhook.scope
  custom_headers      = var.container_registry_webhook.custom_headers
}

