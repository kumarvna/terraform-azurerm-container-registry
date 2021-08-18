# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "container-registry" {
  //  source  = "kumarvna/container-registry/azurerm"
  // version = "1.0.0"
  source = "../../"

  # By default, this module will not create a resource group. Location will be same as existing RG.
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  # set the argument to `create_resource_group = true` to create new resrouce group.
  resource_group_name = "rg-shared-westeurope-01"
  location            = "westeurope"

  # Azure Container Registry configuration
  # The `Classic` SKU is Deprecated and will no longer be available for new resources
  container_registry_config = {
    name          = "containerregistrydemoproject01"
    admin_enabled = true
    sku           = "Premium"
  }

  # The georeplications is only supported on new resources with the Premium SKU.
  # The georeplications list cannot contain the location where the Container Registry exists.
  georeplications = [
    {
      location                = "northeurope"
      zone_redundancy_enabled = true
    },
    {
      location                = "francecentral"
      zone_redundancy_enabled = true
    },
    {
      location                = "uksouth"
      zone_redundancy_enabled = true
    }
  ]

  # Set a retention policy with care--deleted image data is UNRECOVERABLE.
  # A retention policy for untagged manifests is currently a preview feature of Premium container registries
  retention_policy = {
    days    = 10
    enabled = true
  }

  # Content trust is a feature of the Premium service tier of Azure Container Registry.
  enable_content_trust = true

  # Using Azure Container Registry webhooks
  # The endpoint for a webhook must be publicly accessible from the registry. 
  container_registry_webhooks = {
    webhook1 = {
      service_uri = "https://mywebhookreceiver.example/mytag"
      status      = "enabled"
      scope       = "mytag:*"
      actions     = ["push"]
      custom_headers = {
        "Content-Type" = "application/json"
      }
    },
    webhook2 = {
      service_uri = "https://mywebhookreceiver.example/app1"
      status      = "enabled"
      scope       = "app1:*"
      actions     = ["push"]
      custom_headers = {
        "Content-Type" = "application/json"
      }
    }
  }
  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.mysql.database.azure.com` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  enable_private_endpoint       = true
  virtual_network_name          = "vnet-shared-hub-westeurope-001"
  private_subnet_address_prefix = ["10.1.5.0/27"]
  #  existing_private_dns_zone     = "demo.example.com"

  # (Optional) To enable Azure Monitoring for Azure MySQL database
  # (Optional) Specify `storage_account_name` to save monitoring logs to storage. 
  log_analytics_workspace_name = "loganalytics-we-sharedtest2"

  # Adding TAG's to your Azure resources 
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
