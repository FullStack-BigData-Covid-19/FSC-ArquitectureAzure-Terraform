terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}
provider "azurerm" {
    features {}
}
resource "azurerm_resource_group" "fsc-rg-main"{
    name = "rg-fullStack-covid19-arturo"
    location = var.location
    tags = var.tags
}

resource "azurerm_storage_account" "fsc-storage-terraform-state" {
    depends_on = [azurerm_resource_group.fsc-rg-main]
    name = "saterraformstatearturo"
    resource_group_name = azurerm_resource_group.fsc-rg-main.name
    location = var.location
    account_kind = "StorageV2"
    account_tier = "Standard"
    access_tier = "Hot"
    account_replication_type = "LRS"
    enable_https_traffic_only = true
    tags = var.tags
    lifecycle {
        prevent_destroy = true
    }
}

resource "azurerm_storage_container" "fsc-container-terraform-state"{
    depends_on = [azurerm_storage_account.fsc-storage-terraform-state]
    name = "container-terraform-state"
    storage_account_name = azurerm_storage_account.fsc-storage-terraform-state.name
}