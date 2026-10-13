terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.9.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "dev"
    storage_account_name = "theramya10"
    container_name       = "theramya10"
    key                  = "terraform.tfstate-prod"

  }
}


provider "azurerm" {
  features {}

}