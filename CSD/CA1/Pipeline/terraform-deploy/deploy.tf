resource "azurerm_container_registry" "acr" {
  name                = "cdillonacipoc"
  resource_group_name = var.rg
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true  
}

