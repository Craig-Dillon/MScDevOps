  terraform {
    backend "azurerm" {
      tenant_id                = "*"
      subscription_id          = "*"
      client_secret            = "*"
      client_id                = "*"
      resource_group_name      = "*"
      storage_account_name     = "*"
      container_name           = "*"
      key                      = "*"
  }
  }