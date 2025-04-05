terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "phonebook_rg" {
  name     = "phonebook-app-rg"
  location = "eastus"
}

resource "azurerm_service_plan" "phonebook_plan" {
  name                = "phonebook-app-service-plan"
  resource_group_name = azurerm_resource_group.phonebook_rg.name
  location            = azurerm_resource_group.phonebook_rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "phonebook_app" {
  name                = "phonebook-app-${lower(substr(sha1(var.app_version), 0, 8))}"
  resource_group_name = azurerm_resource_group.phonebook_rg.name
  location            = azurerm_service_plan.phonebook_plan.location
  service_plan_id     = azurerm_service_plan.phonebook_plan.id

  site_config {
    application_stack {
      node_version = "14-lts"
    }
    app_command_line = "npm run start"
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    REACT_APP_API_ENDPOINT   = var.api_endpoint
  }
}

output "app_url" {
  value = "https://${azurerm_linux_web_app.phonebook_app.default_hostname}"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "app_version" {
  default = "1.0.0"
}
variable "api_endpoint" {
  default = "https://api.example.com"
}
