data "terraform_remote_state" "remote" {
    backend = "azurerm"
    config = {
        resource_group_name = "rg-terraform-state-covid19"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "datalake.tfstate"
    }
}

resource "azurerm_synapse_workspace" "fsc-synapse-workspace" {
  name                                 = "fsc-synapse-workspace"
  resource_group_name                  = data.terraform_remote_state.remote.outputs.rg-datalake.name
  location                             = data.terraform_remote_state.remote.outputs.rg-datalake.location
  storage_data_lake_gen2_filesystem_id = data.terraform_remote_state.remote.outputs.raw-container.id
  sql_administrator_login              = "smitexx"
  sql_administrator_login_password     = "Pa5ss19w"
  identity {
    type = "SystemAssigned"
  }
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