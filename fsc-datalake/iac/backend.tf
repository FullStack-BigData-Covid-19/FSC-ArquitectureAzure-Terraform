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
       resource_group_name = "training_and_demos"
       storage_account_name = "saterraformstatearturo"
       container_name = "container-terraform-state"
       key = "datalake.tfstate"
    }
    
}
