terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "azurerm" {
    tenant_id                = "cd9e8269-dfb6-48e0-8253-8b7baf8d3391"
    subscription_id          = "947aa7a3-d535-4bcb-aa86-8b255f29b8e2"
    resource_group_name      = "k8s_testing"
    storage_account_name     = "tfbackendk8s"
    container_name           = "terraform"
    key                      = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
    skip_provider_registration = "true"
}


