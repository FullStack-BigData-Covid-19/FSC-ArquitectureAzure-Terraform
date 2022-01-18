/*data "terraform_remote_state" "sql-onpremise" {
    backend = "azurerm"
    config = {
    storage_account_name = "saterraformstatearturo"
    container_name       = "container-terraform-state"
    key                  = "sql-onpremise.tfstate"
  }
}*/
# Create the SQL Server 
resource "azurerm_mssql_server" "fsc-sql-server" {
  name = "fsc-sql-server-onpremise-instance" #NOTE: globally unique
  resource_group_name = data.terraform_remote_state.sql-onpremise.resource_group_name
  location = var.location
  version = "12.0"
  administrator_login = "smitexx"
  administrator_login_password = "Pa5ss19w"
  public_network_access_enabled = false
  tags = var.tags
}
# Create a the SQL database 
resource "azurerm_sql_database" "fsc-sql-db" {
  depends_on = [azurerm_mssql_server.fsc-sql-server]
  name = "covid19-db"
  resource_group_name =  data.terraform_remote_state.sql-onpremise.resource_group_name
  location = var.location
  server_name = azurerm_mssql_server.fsc-sql-server.name
  edition = "Basic"
  collation = "Latin1_General_CI_AS"
  max_size_bytes = "10200000000"
  zone_redundant = false
  read_scale = false
  tags = var.tags
}