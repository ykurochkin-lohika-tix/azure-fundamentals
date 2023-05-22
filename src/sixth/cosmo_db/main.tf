resource "azurerm_resource_group" "sql-pay-for-it-rg" {
  name     = "sql-pay-for-it-rg"
  location = "East US"
}

resource "azurerm_sql_server" "my_sql_server" {
  name                         = "my-sql-server"
  resource_group_name          = azurerm_resource_group.sql-pay-for-it-rg.name
  location                     = azurerm_resource_group.sql-pay-for-it-rg.location
  version                      = "12.0"
  administrator_login          = "adminlogin"
  administrator_login_password = "P@ssw0rd1234!"
}

resource "azurerm_sql_database" "my_sql_database" {
  name                = "my-sql-database"
  resource_group_name = azurerm_resource_group.sql-pay-for-it-rg.name
  location            = azurerm_resource_group.sql-pay-for-it-rg.location
  server_name         = azurerm_sql_server.my_sql_server.name
  edition             = "GeneralPurpose"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
}