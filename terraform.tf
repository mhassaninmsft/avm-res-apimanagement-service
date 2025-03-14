# terraform {
#   required_version = "~> 1.5"
#   required_providers {
#     # TODO: Ensure all required providers are listed here and the version property includes a constraint on the maximum major version.
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.71"
#     }
#     modtm = {
#       source  = "azure/modtm"
#       version = "~> 0.3"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "~> 3.5"
#     }
#   }
# }

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


# # Configure the Microsoft Azure Provider
# provider "azurerm" {
#   features {}
#   # If you're using Azure CLI authentication, you don't need to specify credentials here
#   # For other authentication methods, add the necessary credentials
# }
