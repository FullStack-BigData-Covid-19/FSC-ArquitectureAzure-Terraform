terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-terraform-state-covid19"
  location = var.location
  tags = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "saterraformstatearturo"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags =  var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "container-terraform-state"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}