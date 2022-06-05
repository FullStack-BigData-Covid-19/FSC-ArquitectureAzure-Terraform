############### PROVIDER ###############
provider "azurerm" {
    features {
      key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
############### DATA ###############
data "terraform_remote_state" "sp" {
    backend = "azurerm"
    config = {
        resource_group_name = "training_and_demos"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "service-principal.tfstate"
    }
}
data "terraform_remote_state" "dl" {
    backend = "azurerm"
    config = {
        resource_group_name = "training_and_demos"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "datalake.tfstate"
    }
}
data "terraform_remote_state" "synapse" {
    backend = "azurerm"
    config = {
        resource_group_name = "training_and_demos"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "synapse-analytics.tfstate"
    }
}
data "azurerm_client_config" "current" {}

############### RESOURCES ###############
resource "azurerm_key_vault" "fsc-keyvault" {
  name                        = "fsc-keyvault-covid19"
  location                    = var.location
  resource_group_name         = "training_and_demos"
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

resource "azurerm_key_vault_secret" "sp-app-id" {
  name         = "sp-app-id"
  value        =  data.terraform_remote_state.sp.outputs.service_principal.application_id
  key_vault_id = azurerm_key_vault.fsc-keyvault.id
}
resource "azurerm_key_vault_secret" "tenant-id" {
  name         = "tenant-id"
  value        =   data.terraform_remote_state.sp.outputs.service_principal.application_tenant_id
  key_vault_id = azurerm_key_vault.fsc-keyvault.id
}
resource "azurerm_key_vault_secret" "sp-secret" {
  name         = "sp-secret"
  value        = data.terraform_remote_state.sp.outputs.client_secret
  key_vault_id = azurerm_key_vault.fsc-keyvault.id
}
resource "azurerm_key_vault_secret" "dl-key-secret" {
  name         = "dl-key"
  value        = data.terraform_remote_state.dl.outputs.dl-storage-account.primary_access_key
  key_vault_id = azurerm_key_vault.fsc-keyvault.id
}
resource "azurerm_key_vault_secret" "synapse-pass" {
  name         = "synapse-pass"
  value        = data.terraform_remote_state.synapse.outputs.synapse_workspace.sql_administrator_login_password
  key_vault_id = azurerm_key_vault.fsc-keyvault.id
}

############### OUTPUTS ###############
output "key_vault" {
  value = azurerm_key_vault.fsc-keyvault
  description = "Key Vault" 
}
output "sp_secret" {
  value = azurerm_key_vault_secret.sp-secret.value
  description = "Service principal secret"
  sensitive = false
}
output "tenant_id" {
  value = azurerm_key_vault_secret.tenant-id.value
  description = "Tenant id"
  sensitive = false
}
output "dl_primary_key" {
  value = azurerm_key_vault_secret.dl-key-secret.value
  description = "Datalake primary key"
  sensitive = false
}
output "sp_app_id" {
  value = azurerm_key_vault_secret.sp-app-id.value
  description = "App id of service principal"
  sensitive = false
}
output "synapse_pass" {
  value = azurerm_key_vault_secret.synapse-pass.value
  description = "Password of admin sql user in synapse"
  sensitive = false
}