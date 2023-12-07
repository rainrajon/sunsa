resource "azurerm_virtual_network" "vnet" {
 name                = var.virtual_network_name
 location            = var.resource_group_location
 resource_group_name = azurerm_resource_group.rg.name
 address_space       = [var.address_space]
}
resource "azurerm_subnet" "subnet_storage" {
 name                 = var.subnet_storage_name
 resource_group_name  = var.resource_group_name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes     = [var.subnet_storage_cidr]
 service_endpoints    = ["Microsoft.Storage"]
}
resource "azurerm_subnet" "subnet_computer_vision" {
 name                 = var.subnet_computer_vision_name
 resource_group_name  = var.resource_group_name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes     = [var.subnet_computer_vision_cidr]
 service_endpoints    = ["Microsoft.CognitiveServices"]
 }
resource "azurerm_subnet" "subnet_openai" {
 name                 = var.subnet_openai_name
 resource_group_name  = var.resource_group_name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes     = [var.subnet_openai_cidr]
 service_endpoints    = ["Microsoft.CognitiveServices"]
}
resource "azurerm_subnet" "subnet_container_registry" {
 name                 = var.subnet_container_registry_name
 resource_group_name  = var.resource_group_name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes     = [var.subnet_container_registry_cidr]
 service_endpoints    = ["Microsoft.ContainerRegistry"]
}
resource "azurerm_subnet" "subnet_container_instance" {
 name                 = var.subnet_container_instance_name
 resource_group_name  = var.resource_group_name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes     = [var.subnet_container_instance_cidr]
 service_endpoints    = ["Microsoft.CognitiveServices","Microsoft.Storage"]
}
resource "azurerm_storage_account" "adls_storage_account" {
  name                = var.adls_account_name
  resource_group_name = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    CostCenter : "20060000"
    Application : "Windows"
    Product : "Storage Conditions"
    SupportTeam : "team_sc@fdbhealth.com"
    enviroment = "NonProd"
  }
}
resource "azurerm_storage_container" "container" {
 name                  = var.container_name
 storage_account_name  = azurerm_storage_account.adls_storage_account.name
 container_access_type = "private"
}
resource "azurerm_cognitive_account" "computer_vision" {
  name                = var.computer_vision_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  kind                = "ComputerVision"
  
  sku_name = "S1"
  custom_subdomain_name = var.computer_vision_name
  tags = {
    CostCenter : "20060000"
    Application : "Windows"
    Product : "Storage Conditions"
    SupportTeam : "team_sc@fdbhealth.com"
    enviroment = "NonProd"
  }
}
resource "azurerm_search_service" "ai_search" {
  name                = var.azure_search_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  replica_count       = "1"
  partition_count     = "1"
}
resource "azurerm_cognitive_account" "openai" {
  name                = var.openai_name
  location            = "East US 2"
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"

  sku_name = "S0"
  custom_subdomain_name = var.openai_name
  tags = {
    CostCenter : "20060000"
    Application : "Windows"
    Product : "Storage Conditions"
    SupportTeam : "team_sc@fdbhealth.com"
    enviroment = "NonProd"
  }
}
resource "azurerm_cognitive_deployment" "openai_deployment" {
  name                 = var.deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0613"
  }

  scale {
    type = "Standard"
    capacity = "120"
  }
}
resource "azurerm_cognitive_deployment" "openai_deployment" {
  name                 = var.deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "0613"
  }

  scale {
    type = "Standard"
    capacity = "10"
  }
}
resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  admin_enabled       = true
}

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "key-vault" {
    name = var.key_vault_name
    location = var.resource_group_location
    resource_group_name = var.resource_group_name

    enabled_for_deployment = "true"
    enabled_for_disk_encryption = "true"
    enabled_for_template_deployment = "true"

    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "standard"
    network_acls {
       default_action = "Allow"
       bypass = "AzureServices"
    }
    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id
        key_permissions = ["Create", "Get", "List", "Purge", "Recover",]
        secret_permissions = ["Get", "List", "decrypt", "Purge", "Recover", "Set"]
        certificate_permissions = ["Create", "Get", "List", "Purge", "Recover", "Update"]
         }
}
resource "azurerm_key_vault_secret" "vision_subscription_key" {
   name         = "SUBSCRIPTION-KEY"
   value        = azurerm_cognitive_account.computer_vision.primary_access_key
   key_vault_id = azurerm_key_vault.key-vault.id
   depends_on = [azurerm_cognitive_account.computer_vision]
}
resource "azurerm_key_vault_secret" "openai_subscription_key" {
   name         = "AZURE-OPENAI-KEY"
   value        = azurerm_cognitive_account.openai.primary_access_key
   key_vault_id = azurerm_key_vault.key-vault.id
   depends_on = [azurerm_cognitive_account.openai]
}
resource "azurerm_key_vault_secret" "openai_endpoint" {
   name         = "AZURE-OPENAI-ENDPOINT"
   value        = azurerm_cognitive_account.openai.endpoint
   key_vault_id = azurerm_key_vault.key-vault.id
   depends_on = [azurerm_cognitive_account.openai]
}
resource "azurerm_key_vault_secret" "BLOB_STORAGE_CONNECTION_STRING" {
   name         = "BLOB-STORAGE-CONNECTION-STRING"
   value        = azurerm_storage_account.adls_storage_account.primary_connection_string
   key_vault_id = azurerm_key_vault.key-vault.id
   depends_on = [azurerm_storage_account.adls_storage_account]
}
resource "azurerm_key_vault_secret" "vector_address" {
   name         = "VECTOR-STORE-ADDRESS"
   value        = "https://cogsearchprod.search.windows.net"
   key_vault_id = azurerm_key_vault.key-vault.id
   depends_on = [azurerm_search_service.ai_search]
}
resource "azurerm_key_vault_secret" "vector_password" {
   name         = "VECTOR-STORE-PASSWORD"
   value        = azurerm_search_service.ai_search.primary_key
   key_vault_id = azurerm_key_vault.key-vault.id
   depends_on = [azurerm_search_service.ai_search]
}
