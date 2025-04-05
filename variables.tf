# variables.tf

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure service principal client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  sensitive   = true
}

variable "app_version" {
  description = "Application version for unique naming"
  type        = string
  default     = "1.0.0"
}

variable "api_endpoint" {
  description = "API endpoint for the phone book app"
  type        = string
  default     = "https://api.example.com"
}