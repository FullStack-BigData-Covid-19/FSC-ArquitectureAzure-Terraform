provider "azurerm" {
    features {}
}
terraform{
    backend "azurerm" {
       resource_group_name = "rg-fullStack-covid19-arturo"
       storage_account_name = "saterraformstatearturo"
       container_name = "container-terraform-state"
       key = "sql-onpremise.tfstate"
    }
    
}