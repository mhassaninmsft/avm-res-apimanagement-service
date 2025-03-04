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

# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = module.regions.regions[random_integer.region_index.result].name
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "this" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location                      = azurerm_resource_group.this.location
  name                          = module.naming.api_management.name_unique
  resource_group_name           = azurerm_resource_group.this.name
  publisher_email               = var.publisher_email
  publisher_name                = var.publisher_name
  sku_name                      = var.sku
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry
  public_network_access_enabled = var.virtual_network_type == "Internal" ? false : true
  public_ip_address_id          = var.virtual_network_type == "Internal" ? "" : var.public_ip_address_id
  virtual_network_type          = var.virtual_network_type
  virtual_network_configuration = var.virtual_network_type == "None" ? {} : {
    subnet_id = var.subnet_id
  }
}