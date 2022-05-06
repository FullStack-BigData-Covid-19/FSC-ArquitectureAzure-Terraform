############### RESOURCES ###############
resource "azurerm_resource_group" "fsc-rg-dl"{
    name = "rg-covid19-arturo"
    location = var.location
    tags = var.tags
}

resource "azurerm_storage_account" "fsc-datalake" {
    depends_on = [azurerm_resource_group.fsc-rg-dl]
    name = "fscdatalakecovid19"
    resource_group_name = azurerm_resource_group.fsc-rg-dl.name
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

############### OUTPUTS ###############
output "raw-container" {
  value = azurerm_storage_data_lake_gen2_filesystem.raw
}

output "dl-storage-account" {
  value       = azurerm_storage_account.fsc-datalake
  description = "Datalake Storage Account"
  
}

output "rg-datalake" {
  value       = azurerm_resource_group.fsc-rg-dl
  description = "Resource Group Main"
} 