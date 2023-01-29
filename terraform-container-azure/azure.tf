# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "dv_sample" {
  name     = "DV-Sample-RG"
  location = "West US"
}

resource "azurerm_service_plan" "dv_sample" {
  name                = "TF-Deployment-Plan"
  resource_group_name = azurerm_resource_group.dv_sample.name
  location            = azurerm_resource_group.dv_sample.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "dv_sample" {
  name                = "DV-Sample-App"
  resource_group_name = azurerm_resource_group.dv_sample.name
  location            = azurerm_service_plan.dv_sample.location
  service_plan_id     = azurerm_service_plan.dv_sample.id

  site_config {
    always_on = true # Cannot be `true` with F1 SKU
  }

  app_settings = {
    ENVID      = module.environment.environment_id
    DVDOMAIN   = local.pingone_domain
    DVPOLICYID = local.app_policy[var.app_policy_name]
    DVAPIKEY   = davinci_application.initial_policy.api_keys.prod
  }

}

resource "azurerm_app_service_source_control" "example" {
  app_id   = azurerm_linux_web_app.dv_sample.id
  repo_url = "https://github.com/cprice-ping/Packaging-DV-Demo.git"
  branch   = "dv-app"
}