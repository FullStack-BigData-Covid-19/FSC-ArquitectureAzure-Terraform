data "terraform_remote_state" "remote" {
    backend = "azurerm"
    config = {
        resource_group_name = "rg-fullStack-covid19-arturo"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "backend-resources.tfstate"
    }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fsc-datalake-main" {
  name               = "fsc-datalake-main"
  storage_account_id = data.terraform_remote_state.remote.outputs.tfstate-storage-account.id
}


resource "azurerm_synapse_workspace" "fsc-synapse-workspace" {
  name                                 = "fsc-synapse-workspace"
  resource_group_name                  = data.terraform_remote_state.remote.outputs.resource-group-main.name
  location                             = data.terraform_remote_state.remote.outputs.resource-group-main.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fsc-datalake-main.id
  sql_administrator_login              = "smitexx"
  sql_administrator_login_password     = "Pa5ss19w"
  tags = var.tags
}

resource "azurerm_synapse_firewall_rule" "fsc-synapse-rule" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.fsc-synapse-workspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

resource "azurerm_synapse_sql_pool" "fsc-sql-pool" {
  name                 = "fsc_dwh_sql"
  synapse_workspace_id = azurerm_synapse_workspace.fsc-synapse-workspace.id
  sku_name             = "DW100c"
  create_mode          = "Default"
  tags = var.tags
}