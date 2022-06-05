############### DATA ###############
data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "client" {
}
data "terraform_remote_state" "remote" {
    backend = "azurerm"
    config = {
        resource_group_name = "training_and_demos"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "service-principal.tfstate"
    }
}
############### RESOURCES ###############
resource "azurerm_storage_account" "fsc-datalake" {
    name = "fscdatalakecovid19"
    resource_group_name = "training_and_demos"
    location = var.location
    account_kind = "StorageV2"
    account_tier = "Standard"
    access_tier = "Hot"
    account_replication_type = "LRS"
    enable_https_traffic_only = true
    is_hns_enabled = true
    tags = var.tags
    lifecycle {
        prevent_destroy = true
    }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw" {
  name               = "raw"
  storage_account_id = azurerm_storage_account.fsc-datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "curated" {
  name               = "curated"
  storage_account_id = azurerm_storage_account.fsc-datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "enterprise" {
  name               = "enterprise"
  storage_account_id = azurerm_storage_account.fsc-datalake.id
}

resource "azurerm_role_assignment" "usuario-dl" {
  scope                = azurerm_storage_account.fsc-datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.client.object_id
}
resource "azurerm_role_assignment" "sp-dl" {
  scope                = azurerm_storage_account.fsc-datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.terraform_remote_state.remote.outputs.service_principal.id
}


############### OUTPUTS ###############
output "raw-container" {
  value = azurerm_storage_data_lake_gen2_filesystem.raw
}

output "dl-storage-account" {
  value       = azurerm_storage_account.fsc-datalake
  description = "Datalake Storage Account"
  
}
