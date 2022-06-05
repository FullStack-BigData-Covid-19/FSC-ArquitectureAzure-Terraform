terraform{
    required_providers {
      databricks = {
          source = "databrickslabs/databricks"
      }
    } 

    backend "azurerm" {
       resource_group_name = "training_and_demos"
       storage_account_name = "saterraformstatearturo"
       container_name = "container-terraform-state"
       key = "databricks.tfstate"
    }
}