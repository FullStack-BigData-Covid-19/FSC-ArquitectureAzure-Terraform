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
terraform{
    backend "azurerm" {
       resource_group_name = "rg-fullStack-covid19-arturo"
       storage_account_name = "saterraformstatearturo"
       container_name = "container-terraform-state"
       key = "backend-resources.tfstate"
    }
    
}