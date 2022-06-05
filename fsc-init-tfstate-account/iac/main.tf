
############### RESOURCES ###############
resource "azurerm_storage_account" "tfstate" {
  name                     = "saterraformstatearturo"
  resource_group_name      = "training_and_demos"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags =  var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "container-terraform-state"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}