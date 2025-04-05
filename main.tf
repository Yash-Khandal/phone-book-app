terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"  # Update to match the locked version
    }
  }
}

provider "azurerm" {
  features {}
}

variable "subscription_id" {
  default = "6c1e198f-37fe-4942-b348-c597e7bef44b"
}
variable "client_id" {
  default = "0e6e41d3-5440-4176-a735-9dfdaf0f886c"
}
variable "client_secret" {
  default = "LvU8Q~KHHAnB.prsihzhfKNBDsf6UwLqFBGVBcsY"
}
variable "tenant_id" {
  default = "341f4047-ffad-4c4a-a0e7-b86c7963832b"
}
variable "resource_group_name" {
  default = "phonebook-app-rg"
}
variable "location" {
  default = "East US"
}
variable "app_service_plan" {
  default = "phonebook-app-plan"
}
variable "web_app_name" {
  default = "phonebook-app"
}

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
    
    # For serving static React files
    app_command_line = "npm install -g serve && serve -s /home/site/wwwroot -l 8080"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    SCM_DO_BUILD_DURING_DEPLOYMENT      = "false"
    
    # Environment variables for your React app can go here
    REACT_APP_API_BASE_URL = "https://api.example.com"
  }

  # Disable source control integration since we're deploying via Jenkins
  lifecycle {
    ignore_changes = [
      site_config[0].scm_type
    ]
  }
}

# Output the web app URL
output "webapp_url" {
  value = "https://${azurerm_linux_web_app.app.default_hostname}"
}
