terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "resource_group_name" {}
variable "location" {}
variable "app_service_plan" {}
variable "web_app_name" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.web_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
    always_on = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    SCM_DO_BUILD_DURING_DEPLOYMENT      = "false"
  }
}

output "webapp_url" {
  value = "https://${azurerm_linux_web_app.app.default_hostname}"
}
