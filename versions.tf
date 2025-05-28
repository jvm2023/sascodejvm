terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

# Default provider — REQUIRED
provider "azurerm" {
  features {}

  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
  subscription_id = ""
}