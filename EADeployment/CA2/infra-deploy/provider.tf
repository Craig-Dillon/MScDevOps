terraform {
    required_providers {
      azapi = {
        source = "azure/azapi"
        version = "~>1.5"
      }
    }
}

provider "azurerm" {
  features {}
    skip_provider_registration = "true"
    subscription_id = var.subscription
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
}
