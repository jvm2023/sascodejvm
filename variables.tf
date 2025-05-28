variable "aks_subnet_name" {
  description = "The subnet name in your custom VNet for AKS nodes"
  type        = string
}

variable "anf_subnet_name" {
  description = "The subnet name in your custom VNet for anf volumes"
  type        = string
}

variable "name_of_akscluster" {
  description = "name of aks cluster "
  type        = string
}



variable "location_of_akscluster" {
  description = "location of aks cluster"
  type        = string
}


variable "resource_grp_name" {
  description = "resource grp name"
  type        = string
  
}


variable "key_vault_name" {
  description = "key vault name"
  type        = string
  
}



variable "acrname" {
  description = "key vault name"
  type        = string
  
}


variable "nameof_vnet" {
  description = "vnet name"
  type        = string
  
}

variable "addressspaceofvnet" {
  description = "address space of vnet "
  type        = string
  
}
variable "name_aks_subnet" {
  description = "aks subnet nname "
  type        = string
  
}

variable "addressspace_aks_subnet" {
  description = "aks subnet address subnet range "
  type        = string
  
}

variable "name_anf_subnet" {
  description = "anf subnet name"
  type        = string
  
}

variable "addressspace_anf_subnet" {
  description = "anf subnet range "
  type        = string
  
}

variable "storage_account_name" {
  description = "name_of_stroage_account"
  type        = string
  
}




