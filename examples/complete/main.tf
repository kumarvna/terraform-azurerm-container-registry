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


  container_registry_config = {
    name          = "containerregistrydemoproject01"
    admin_enabled = true
    sku           = "Premium"
  }

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

  #  Add `Microsoft.ContainerRegistry` to subnet's ServiceEndpoints collection before adding specific subnets
  /*   network_rule_set = {
    default_action = "Deny"
    ip_rule = [
      {
        ip_range = "49.204.225.49/32"
      },
    ]
    virtual_network = [
      {
        subnet_id = "/subscriptions/1e3f0eeb-2235-44cd-b3a3-dcded0861d06/resourceGroups/rg-shared-westeurope-01/providers/Microsoft.Network/virtualNetworks/vnet-shared-hub-westeurope-001/subnets/snet-appgateway"
      },
      {
        subnet_id = "/subscriptions/1e3f0eeb-2235-44cd-b3a3-dcded0861d06/resourceGroups/rg-shared-westeurope-01/providers/Microsoft.Network/virtualNetworks/vnet-shared-hub-westeurope-001/subnets/snet-management"
      }
    ]
  } */

  # Set a retention policy with care--deleted image data is UNRECOVERABLE.
  # A retention policy for untagged manifests is currently a preview feature of Premium container registries
  retention_policy = {
    days    = 10
    enabled = true
  }

  # Content trust is a feature of the Premium service tier of Azure Container Registry.
  enable_content_trust = true

  # Create a token with repository-scoped permissions
  # To configure repository-scoped permissions, need to create a token with an associated scope map
  # This feature is available in the Premium container registry service tier
  /* scope_map = {
    name = "example-scope-map"
    actions = [
      "repositories/repo1/read",
      "repositories/repo1/create"
    ]
  }
   */
  create_container_registry_token = true

  container_registry_webhook = {
    service_uri = "https://mywebhookreceiver.example/mytag"
    status      = "enabled"
    scope       = "mytag:*"
    actions     = ["push"]
    custom_headers = {
      "Content-Type" = "application/json"
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
