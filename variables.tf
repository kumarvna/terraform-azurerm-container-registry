variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "container_registry_config" {
  type = object({
    name                          = string
    admin_enabled                 = optional(bool)
    sku                           = optional(string)
    public_network_access_enabled = optional(bool)
    quarantine_policy_enabled     = optional(bool)
    zone_redundancy_enabled       = optional(bool)
  })
  description = "Manages an Azure Container Registry"
}
/* 
variable "georeplications" {
  type = object({
    location                = string
    zone_redundancy_enabled = optional(bool)
  })
  description = "A list of Azure locations where the container registry should be geo-replicated"
  default     = null
}

 */
 variable "georeplications" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool)
  }))
  description = "A list of Azure locations where the container registry should be geo-replicated"
  default     = []
}

variable "network_rule_set" {
  type = object({
    default_action = optional(string)
    ip_range       = list(string)
    subnet_id      = list(string)
  })
  description = "Manage network rules for Azure Container Registries"
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

