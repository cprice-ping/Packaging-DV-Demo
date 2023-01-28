terraform {
  required_providers {
    pingone = {
      source = "pingidentity/pingone"
      # version = "~> 0.4"
    }
    davinci = {
      source = "pingidentity/davinci"
    }
    time = {
      source = "hashicorp/time"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.41.0"
    }
  }
}
