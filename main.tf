# main.tf

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "phonebook_rg" {
  name     = "phonebook-app-rg"
  location = "East US"
}

resource "azurerm_app_service_plan" "phonebook_plan" {
  name                = "phonebook-app-service-plan"
  location            = azurerm_resource_group.phonebook_rg.location
  resource_group_name = azurerm_resource_group.phonebook_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "phonebook_app" {
  name                = "phonebook-app-${lower(substr(sha1(var.app_version), 0, 8))}"
  location            = azurerm_resource_group.phonebook_rg.location
  resource_group_name = azurerm_resource_group.phonebook_rg.name
  app_service_plan_id = azurerm_app_service_plan.phonebook_plan.id

  site_config {
    linux_fx_version = "NODE|14-lts"
    app_command_line = "npm run start"
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE       = "1"
    WEBSITE_NODE_DEFAULT_VERSION   = "14-lts"
    REACT_APP_API_ENDPOINT         = var.api_endpoint
  }
}

# Output the application URL
output "app_url" {
  value = "https://${azurerm_app_service.phonebook_app.default_site_hostname}"
}