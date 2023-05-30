####Create the mysql server and databases
resource "azurerm_mysql_server" "production" {
  name                = "production-mysql-server-09238091234"
  location            = var.location
  resource_group_name = var.resource_group
  version             = "5.7"
  administrator_login          = "mysqladmin"
  administrator_login_password = "AV3ry1nsecurepassword"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
  }

output "mysql_server_prod" {
  value = azurerm_mysql_server.production.name
}


resource "azurerm_mysql_database" "production" {
  name                = "productiondb"
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_server.production.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

#resource "azurerm_mysql_server" "staging" {
#  name                = "staging-mysql-server-09238091234"
#  location            = var.location
#  resource_group_name = var.resource_group
#  version             = "5.7"
#  administrator_login          = "mysqladmin"
#  administrator_login_password = "AV3ry1nsecurepassword"
#
#  sku_name   = "GP_Gen5_2"
#  storage_mb = 5120
#
#  auto_grow_enabled                 = true
#  backup_retention_days             = 7
#  geo_redundant_backup_enabled      = true
#  infrastructure_encryption_enabled = true
#  public_network_access_enabled     = false
#  ssl_enforcement_enabled           = true
#  ssl_minimal_tls_version_enforced  = "TLS1_2"
#}
#
#output "mysql_server_staging" {
#  value = azurerm_mysql_server.staging.name
#}
#
#resource "azurerm_mysql_database" "staging" {
#  name                = "stagingdb"
#  resource_group_name = var.resource_group
#  server_name         = azurerm_mysql_server.staging.name
#  charset             = "utf8"
#  collation           = "utf8_unicode_ci"
#}
#
#resource "azurerm_mysql_server" "dev" {
#  name                = "dev-mysql-server-09238091234"
#  location            = var.location
#  resource_group_name = var.resource_group
#  version             = "5.7"
#  administrator_login          = "mysqladmin"
#  administrator_login_password = "AV3ry1nsecurepassword"
#
#  sku_name   = "GP_Gen5_2"
#  storage_mb = 5120
#
#  auto_grow_enabled                 = true
#  backup_retention_days             = 7
#  geo_redundant_backup_enabled      = true
#  infrastructure_encryption_enabled = true
#  public_network_access_enabled     = false
#  ssl_enforcement_enabled           = true
#  ssl_minimal_tls_version_enforced  = "TLS1_2"
#}
#
#output "mysql_server_dev" {
#  value = azurerm_mysql_server.dev.name
#}
#
#resource "azurerm_mysql_database" "dev" {
#  name                = "devdb"
#  resource_group_name = var.resource_group
#  server_name         = azurerm_mysql_server.dev.name
#  charset             = "utf8"
#  collation           = "utf8_unicode_ci"
#}