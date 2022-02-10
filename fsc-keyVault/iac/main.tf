provider "azurerm" {
    features {
      key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
data "terraform_remote_state" "remote" {
    backend = "azurerm"
    config = {
        resource_group_name = "rg-fullStack-covid19-arturo"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "backend-resources.tfstate"
    }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "fsc-keyvault" {
  name                        = "fsc-keyvault-covid19"
  location                    = data.terraform_remote_state.remote.outputs.resource-group-main.location
  resource_group_name         = data.terraform_remote_state.remote.outputs.resource-group-main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    #application_id = id of databricks service principal??
    secret_permissions = ["Get", "List", "Set", "Delete"]
    key_permissions = ["Get", "List", "Create", "Delete"]
    certificate_permissions = ["Get", "List", "Create", "Delete"]
  }
}