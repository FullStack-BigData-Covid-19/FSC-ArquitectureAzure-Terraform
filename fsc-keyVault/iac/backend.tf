terraform{
    backend "azurerm" {
       resource_group_name = "rg-terraform-state-covid19"
       storage_account_name = "saterraformstatearturo"
       container_name = "container-terraform-state"
       key = "key-vault.tfstate"
    }
    
}