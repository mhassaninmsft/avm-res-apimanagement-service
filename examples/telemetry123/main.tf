terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
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

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_log_analytics_workspace" "diag" {
  location            = azurerm_resource_group.this.location
  name                = "diag${module.naming.log_analytics_workspace.name_unique}"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_log_analytics_workspace" "diag2" {
  location            = azurerm_resource_group.this.location
  name                = "diag2${module.naming.log_analytics_workspace.name_unique}"
  resource_group_name = azurerm_resource_group.this.name
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
  # sku_name = "Developer_1"
  tags = {
    environment = "test"
    cost_center = "test"
  }
  enable_telemetry = var.enable_telemetry # see variables.tf
  diagnostic_settings = {
    diag = {
      name                  = "aml${module.naming.monitor_diagnostic_setting.name_unique}"
      workspace_resource_id = azurerm_log_analytics_workspace.diag.id
    #   log_categories = [
    #   "GatewayLogs",       # Logs related to ApiManagement Gateway
    #   "WebSocketConnectionLogs", # Logs related to Websocket Connections
    #   "DeveloperPortalLogs"      # Logs related to Developer Portal usage
    # ]
    },
    diag2 = {
      name                  = "aml2${module.naming.monitor_diagnostic_setting.name_unique}"
      workspace_resource_id = azurerm_log_analytics_workspace.diag2.id
      log_categories = [
      "GatewayLogs",       # Logs related to ApiManagement Gateway
      "WebSocketConnectionLogs", # Logs related to Websocket Connections
      "DeveloperPortalLogs"      # Logs related to Developer Portal usage
      # DeveloperPortalAuditLogs
    ]
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
