terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.74.0"
    }
    azuread = {
      version = "=2.36.0"
      source  = "hashicorp/azuread"
    }
  }
  required_version = ">= 1.5.0"
  backend "azurerm" {
    resource_group_name  = "placeholder"
    storage_account_name = "placeholder"
    container_name       = "placeholder"
    key                  = "placeholder.tfstate"
    subscription_id      = "00000000-0000-0000-0000-000000000000"
  }
}

provider "azuread" {}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  storage_use_azuread             = true
}

data "terraform_remote_state" "sub" {
  backend = "azurerm"
  config = {
    storage_account_name = var.remote_state_backend_storage_account_name
    container_name       = var.remote_state_backend_storage_account_contianer_name
    key                  = var.remote_state_backend_state_file_name
    resource_group_name  = var.remote_state_backend_resource_group_name
    subscription_id      = var.remote_state_backend_subscription_id
  }
}