



terraform {
  backend "azurerm" {
    #provider = azurerm.local
    resource_group_name  = "testaks"
    storage_account_name = "tfstatehpedemo123"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}




