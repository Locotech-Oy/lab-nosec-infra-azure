# Configure the Azure provider
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}

# Create resource group for holding all the lab resources
resource "azurerm_resource_group" "labnosec" {
  name     = var.resource_group_name
  location = "westeurope"
  tags = {
    Environment = var.tag_environment
    Team        = var.tag_team
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "labNoSecVnet"
  address_space       = ["10.10.0.0/16"]
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.labnosec.name

  subnet {
    name           = "labNoSecSubnet1"
    address_prefix = "10.10.1.0/24"
  }

  subnet {
    name           = "labNoSecSubnet2"
    address_prefix = "10.10.2.0/24"
  }
}

# Create a storage account
resource "azurerm_storage_account" "storage" {
  name                = "labnosecsa"
  location            = azurerm_resource_group.labnosec.location
  resource_group_name = azurerm_resource_group.labnosec.name
  account_tier        = "Standard"
  account_replication_type = "LRS"
}

# Create an App service plan (free tier)
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "labNoSecAppServicePlan"
  location            = azurerm_resource_group.labnosec.location
  resource_group_name = azurerm_resource_group.labnosec.name
  kind                = "App"
  sku {
    tier = "Free"
    size = "F1"
  }
}

# Create an App service
resource "azurerm_app_service" "app_service" {
  #checkov:skip=CKV_AZURE_80: The app does not use .NET framework
  name                = "labNoSecAppService"
  location            = azurerm_resource_group.labnosec.location
  resource_group_name = azurerm_resource_group.labnosec.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  https_only          = false
}

# Create an Azure database for MySQL
resource "azurerm_mysql_server" "mysql_server" {
  name                = "labnosec-mysqlserver"
  location            = azurerm_resource_group.labnosec.location
  resource_group_name = azurerm_resource_group.labnosec.name
  administrator_login = var.mysql_admin_user
  administrator_login_password = var.mysql_admin_password
  sku_name                 = "B_Gen5_1"
  version             = "5.7"
  storage_mb          = 5120
  geo_redundant_backup_enabled = false
  public_network_access_enabled = true
  ssl_enforcement_enabled = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
}