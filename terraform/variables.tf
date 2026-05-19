# Azure Service Principal / Subscription
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Service Principal application (client) ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Service Principal client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Active Directory tenant ID"
  type        = string
  sensitive   = true
}

# General
variable "project_name" {
  description = "Project name used as resource name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev / stg / prd)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "japaneast"
}

# SQL
variable "sql_admin_user" {
  description = "SQL Server administrator login name"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "sql_sku_name" {
  description = "Azure SQL Database SKU"
  type        = string
  default     = "Basic"
}

# Functions
variable "functions_sku_tier" {
  description = "App Service Plan SKU tier for Functions"
  type        = string
  default     = "Dynamic"
}

variable "functions_sku_size" {
  description = "App Service Plan SKU size for Functions"
  type        = string
  default     = "Y1"
}
