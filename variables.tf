variable "resource_group_name" {
 description = "Name of the Azure resource group"
 type        = string
 default     = "juvenile"
}
variable "resource_group_location" {
 description = "Location for the Azure resource group"
 type        = string
 default     = "eastus"
}
variable "virtual_network_name" {
 description = "Name of the Azure Virtual Network"
 type        = string
 default     = "vnet-10.0.0.0_16-eastus"
}
variable "address_space" {
 description = "Address space for the Virtual Network"
 type        = string
 default     = "10.0.0.0/16"
}
variable "subnet_storage_name" {
 description = "Name of the storage subnet"
 type        = string
  default     = "subnet-10.0.0.0_24-Private-01"
}
variable "subnet_storage_cidr" {
 description = "CIDR block for the storage subnet"
 type        = string
 default     = "10.0.0.0/24"
}
variable "subnet_computer_vision_name" {
 description = "Name of the computer vision subnet"
 type        = string
 default     = "subnet-10.0.0.0_24-Private"
}
variable "subnet_computer_vision_cidr" {
 description = "CIDR block for the computer vision subnet"
 type        = string
 default     = "10.0.1.0/24"
}
variable "subnet_openai_name" {
 description = "Name of the openai subnet"
 type        = string
 default     = "subnet-10.0.0.0_24-Private-03"
}
variable "subnet_openai_cidr" {
   description = "CIDR block for the openai subnet"
 type        = string
 default     = "10.0.2.0/24"
}
variable "subnet_container_registry_name" {
 description = "Name of the container registry subnet"
 type        = string
 default     = "subnet-10.0.0.0_24-Private-04"
}
variable "subnet_container_registry_cidr" {
 description = "CIDR block for the container registry subnet"
 type        = string
 default     = "10.0.3.0/24"
}
variable "subnet_container_instance_name" {
 description = "Name of the container instance subnet"
 type        = string
 default     = "subnet-10.0.0.0_24-Private-02"
}
variable "subnet_container_instance_cidr" {
 description = "CIDR block for the container instance subnet"
 type        = string
  default     = "10.0.4.0/24"
}
variable "adls_account_name" {
 description = "Name of adls storage account"
 type        = string
 default     = "storagescprod"
}
variable "computer_vision_name" {
 description = "Name of computer vision resource"
 type        = string
 default     = "visionaiscprod"
}
variable "openai_name" {
 description = "Name of openai resource"
 type        = string
 default     = "openai-sc-Prod"
}
variable "container_name" {
 description = "Name of container resource"
 type        = string
 default     = "storageobj"
}
variable "deployment_name" {
 description = "Name of openai resource"
 type        = string
 default     = "openaiscprod"
}
variable "registry_name" {
 description = "Name of container registry"
 type        = string
 default     = "acrscprod"
}
variable "key_vault_name" {
 description = "Name of key vault"
 type        = string
 default     = "kvscprod"
}
variable "azure_search_name" {
 description = "Name of the Azure search service"
 type        = string
 default     = "cogsearchprod"
}
