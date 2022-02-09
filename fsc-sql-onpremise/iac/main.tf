# Create the SQL Server 
resource "azurerm_mssql_server" "fsc-sql-server" {
  name = "fsc-sql-server-onpremise-instance"
  resource_group_name =  var.resource_group_name 
  location = var.location
  version = "12.0"
  administrator_login = "smitexx"
  administrator_login_password = "Pa5ss19w"
  public_network_access_enabled = true
  tags = var.tags
}
# Create a the SQL database 
resource "azurerm_sql_database" "fsc-sql-db" {
  depends_on = [azurerm_mssql_server.fsc-sql-server]
  name = "covid19-db"
  resource_group_name = var.resource_group_name 
  location = var.location
  server_name = azurerm_mssql_server.fsc-sql-server.name
  edition = "Standard"
  collation = "Latin1_General_CI_AS"
  zone_redundant = false
  read_scale = false
  tags = var.tags
}
