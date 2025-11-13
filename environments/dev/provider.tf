terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "95a90f4b-7e15-47ba-95ab-0d52bac078e4"
}
