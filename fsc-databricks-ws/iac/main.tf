############### DATA ###############
data "terraform_remote_state" "kv" {
    backend = "azurerm"
    config = {
        resource_group_name = "training_and_demos"
        storage_account_name = "saterraformstatearturo"
        container_name = "container-terraform-state"
        key            = "key-vault.tfstate"
    }
}

data "databricks_node_type" "fsc-db-node-type" {
  local_disk = true
  min_cores   = 1
  gb_per_core = 1
  min_gpus    = 1
  category = "General Purpose (HDD)"
  depends_on = [azurerm_databricks_workspace.fsc-databricks-ws]
}

data "databricks_spark_version" "fsc-spark-version" {
  depends_on = [azurerm_databricks_workspace.fsc-databricks-ws]
  long_term_support = true
}

############### PROVIDERS ###############
provider "azurerm" {
    features {}
}

provider "databricks" {
    azure_workspace_resource_id = azurerm_databricks_workspace.fsc-databricks-ws.id 
}
############### RESOURCES ###############
resource "azurerm_databricks_workspace" "fsc-databricks-ws" {
  name                = "fsc-databricks-ws"
  resource_group_name = "training_and_demos"
  location            = var.location
  sku                 = "standard"

  tags = var.tags
}

resource "databricks_cluster" "fsc-cluster-databricks" {
  cluster_name            = "FSCluster"
  spark_version           = data.databricks_spark_version.fsc-spark-version.id
  node_type_id            = data.databricks_node_type.fsc-db-node-type.id
  autotermination_minutes = 50
  num_workers             = 1
}

resource "databricks_secret_scope" "fsc" {
  name = "fsc-secret-scope"
  initial_manage_principal = "users"
}

resource "databricks_secret" "sp-secret" {
  key          = "sp-secret"
  string_value = data.terraform_remote_state.kv.outputs.sp_secret
  scope        = databricks_secret_scope.fsc.id
}
resource "databricks_secret" "sp-app-id" {
  key          = "sp-app-id"
  string_value = data.terraform_remote_state.kv.outputs.sp_app_id
  scope        = databricks_secret_scope.fsc.id
}
resource "databricks_secret" "tenant-id" {
  key          = "tenant-id"
  string_value = data.terraform_remote_state.kv.outputs.tenant_id
  scope        = databricks_secret_scope.fsc.id
}
resource "databricks_secret" "dl-primary-key" {
  key          = "dl-primary-key"
  string_value = data.terraform_remote_state.kv.outputs.dl_primary_key
  scope        = databricks_secret_scope.fsc.id
}
resource "databricks_secret" "synapse-pass" {
  key          = "synapse-pass"
  string_value = data.terraform_remote_state.kv.outputs.synapse_pass
  scope        = databricks_secret_scope.fsc.id
}