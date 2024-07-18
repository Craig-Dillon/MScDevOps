variable "subscription" {}

variable "client_id" {
  type        = string
  description = "Client ID for Azure"
}

variable "client_secret" {
  type        = string
  description = "Service account secret for auth"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenancy"
}

variable "rg" {
    type = string
    default = "aks_test"
}

variable "location" {
    type = string
    default = "northeurope"
}

