provider "azurerm" {
  features {}
}

variable "administrator_login" {
  type        = string
}
variable "administrator_login_password" {
  type        = string
}

resource "azurerm_resource_group" "postsql" {
  name     = "postsql-resource-group"
  location = "eastus"
}

resource "azurerm_postgresql_flexible_server" "flexible_psql_server" {
  name                   = "postsql-server-lsnn2"
  resource_group_name    = azurerm_resource_group.postsql.name
  location               = azurerm_resource_group.postsql.location
  version                = "12"
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_login_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"
}

resource "azurerm_postgresql_flexible_server_database" "flexible_psql_db" {
  name      = "psql_flexible_db"
  server_id = azurerm_postgresql_flexible_server.flexible_psql_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "psql_rule" {
  for_each = {
    "142.113.226.55" = "First_IP_Address",
    "172.174.252.2" = "Second_IP_Address"
  }

  name                = "psql_rule_${each.value}"
  server_id           = azurerm_postgresql_flexible_server.flexible_psql_server.id
  start_ip_address    = each.key
  end_ip_address      = each.key
}
