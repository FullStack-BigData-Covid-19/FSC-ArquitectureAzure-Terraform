data "terraform_remote_state" "remote" {
    backend = "azurerm"
    config = {
        resource_group_name = "rg-terraform-state-covid19"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "datalake.tfstate"
    }
}
provider "azurerm" {
    features {}
}

provider "databricks" {
    azure_workspace_resource_id = azurerm_databricks_workspace.fsc-databricks-ws.id 
}

resource "azurerm_databricks_workspace" "fsc-databricks-ws" {
  name                = "fsc-databricks-ws"
  resource_group_name = data.terraform_remote_state.remote.outputs.rg-datalake.name
  location            = data.terraform_remote_state.remote.outputs.rg-datalake.location
  sku                 = "standard"

  tags = var.tags
}

data "databricks_node_type" "fsc-db-node-type" {
  local_disk = true
  min_cores   = 4
  gb_per_core = 14
  min_gpus    = 1
  category = "General Purpose (HDD)"
  depends_on = [azurerm_databricks_workspace.fsc-databricks-ws]
}

data "databricks_spark_version" "fsc-spark-version" {
  depends_on = [azurerm_databricks_workspace.fsc-databricks-ws]
  long_term_support = true
}

resource "databricks_cluster" "fsc-cluster-databricks" {
  cluster_name            = "FSCluster"
  spark_version           = data.databricks_spark_version.fsc-spark-version.id
  node_type_id            = data.databricks_node_type.fsc-db-node-type.id
  autotermination_minutes = 50
  num_workers             = 2
}

