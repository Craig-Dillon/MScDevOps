terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "azurerm" {
    tenant_id                = ""
    subscription_id          = ""
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


