terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name      = "aci_poc"
    storage_account_name     = "cdillonacistorage"
    container_name           = "terraform-deploy"
    key                      = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
    skip_provider_registration = "true"
}
