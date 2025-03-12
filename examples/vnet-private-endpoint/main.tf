terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.21.9"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "azurerm" {
  
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
#     api_management {
# purge_soft_delete_on_destroy = false
#     min_api_version = "2024-10-01-preview"
#     }
  }
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}


// Create a virtual network for testing if needed
# module "virtual_network" {
#   source              = "Azure/avm-res-network-virtualnetwork/azurerm"
#   version             = "~> 0.1.0"
#   name                = module.naming.virtual_network.name_unique
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   address_space       = ["10.0.0.0/16"]

#   subnets = {
#     apim_subnet = {
#       address_prefixes  = ["10.0.1.0/24"]
#       service_endpoints = ["Microsoft.ApiManagement"]
#       delegations       = {}
#     }
#     pe_subnet = {
#       address_prefixes  = ["10.0.2.0/24"]
#       service_endpoints = []
#       delegations       = {}
#     }
#   }
# }


// Create a Private DNS Zone for API Management
module "private_dns_apim" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.azure-api.net"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink-azure-api-net"
      # vnetid       = module.virtual_network.resource.id
      vnetid       = "/subscriptions/aa27a1b3-530a-4637-a1e6-6855033a65e5/resourceGroups/rg-wwgpr/providers/Microsoft.Network/virtualNetworks/vnetwwgpr"
    }
  }
  # tags             = var.tags
  enable_telemetry = var.enable_telemetry
}


# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location = "eastus2" # TODO: Remove this line
  # location            = azurerm_resource_group.this.location
  name                = module.naming.api_management.name_unique # TODO update with module.naming.<RESOURCE_TYPE>.name_unique
  # name                = "TODO" # TODO update with module.naming.<RESOURCE_TYPE>.name_unique
  resource_group_name = azurerm_resource_group.this.name
  publisher_email = "mhassanin@microsoft.com"
  publisher_name = "Mohamed Company"
  sku_name = "Developer_1"
  tags = {
    environment = "test"
    cost_center = "test"
  }
  enable_telemetry = var.enable_telemetry # see variables.tf
  # virtual_network_type = "External"
  # virtual_network_subnet_id = "/subscriptions/aa27a1b3-530a-4637-a1e6-6855033a65e5/resourceGroups/rg-wwgpr/providers/Microsoft.Network/virtualNetworks/vnetwwgpr/subnets/apim-subnet-3"
  virtual_network_type = "None"
  # virtual_network_subnet_id = "/subscriptions/aa27a1b3-530a-4637-a1e6-6855033a65e5/resourceGroups/rg-wwgpr/providers/Microsoft.Network/virtualNetworks/vnetwwgpr/subnets/apim-subnet-4"

  # private endpoints
   // Add private endpoint configuration
  private_endpoints = {
    endpoint1 = {
      name                = "pe-${module.naming.api_management.name_unique}"
      subnet_resource_id  = "/subscriptions/aa27a1b3-530a-4637-a1e6-6855033a65e5/resourceGroups/rg-wwgpr/providers/Microsoft.Network/virtualNetworks/vnetwwgpr/subnets/private_endpoints"
      
      // Link to the private DNS zone we created
      private_dns_zone_resource_ids = [
        module.private_dns_apim.resource.id
      ]
      
      tags = {
        environment = "test"
        service     = "apim"
      }
    }
  }
  
}


# name                = "mhasaaninapim4555"
# resource_group_name = "mhassanin-rg"
# location            = "eastus2"
# publisher_name      = "Mohamed Company"
# publisher_email     = "mhassanin@microsoft.com"
# sku_name            = "Developer_1"

# export ARM_SUBSCRIPTION_ID="aa27a1b3-530a-4637-a1e6-6855033a65e5"
# 
