variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  sensitive   = true
}

variable "app_version" {
  description = "Application version"
  type        = string
  default     = "1.0.0"
}

variable "api_endpoint" {
  description = "API endpoint URL"
  type        = string
  default     = "https://api.example.com"
}
