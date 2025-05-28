provider "azurerm" {
   alias           = "local"
   features {
    netapp {
      prevent_volume_destruction = false
      
    }
  }



  tenant_id       = ""
  client_id       = ""
  client_sec   = ""
  subscription_id = ""
}







/*provider "azurerm" {
  features {
    netapp {
      prevent_volume_destruction             = true
      delete_backups_on_backup_vault_destroy = false
    }
  }
}*/



resource "azurerm_resource_group" "main" {
  name     = var.resource_grp_name
  location = "UK South"  # or "Central India", "West Europe", etc.
}


# Get the existing VNet
/*data "azurerm_virtual_network" "existing_vnet" {
  name                = "testvnettesco"
  resource_group_name = var.resource_grp_name
}

# Get the specific subnet inside that VNet
data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = var.resource_grp_name
}

data "azurerm_subnet" "anf_subnet" {
  name                 = var.anf_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = var.resource_grp_name
  
}*/

resource "azurerm_virtual_network" "example_vnet" {
  name                = var.nameof_vnet
  location            = var.location_of_akscluster
  resource_group_name = var.resource_grp_name
  address_space       = [var.addressspaceofvnet]

  tags = {
    environment = "prod"
  }
  depends_on = [ azurerm_resource_group.main ]
}

/*resource "azurerm_virtual_network_peering" "local_to_peer" {
  provider                  = azurerm.local
  name                      = "peeringab"
  resource_group_name       = var.resource_grp_name
  virtual_network_name      = var.nameof_vnet
  remote_virtual_network_id = "/subscriptions/5361572a-81a1-45bd-880c-9fa83142de1f/resourceGroups/rg-uks-hub-net-01/providers/Microsoft.Network/virtualNetworks/vnet-uks-hub-01"


  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on = [ azurerm_virtual_network.example_vnet,
  azurerm_resource_group.main ]
}*/

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_grp_name
  virtual_network_name = var.nameof_vnet
  address_prefixes     = [var.addressspace_aks_subnet]
  depends_on = [
  azurerm_resource_group.main,
  azurerm_virtual_network.example_vnet
]
}


resource "azurerm_subnet" "anf_subnet" {
  name                 = var.name_anf_subnet
  resource_group_name  = var.resource_grp_name
  virtual_network_name = var.nameof_vnet
  address_prefixes     = [var.addressspace_anf_subnet]
    depends_on = [
  azurerm_resource_group.main,
  azurerm_virtual_network.example_vnet
]
    delegation {
    name = "netapp-delegation"

    service_delegation {
      name = "Microsoft.Netapp/volumes"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name_of_akscluster
  location            = var.location_of_akscluster
  resource_group_name = var.resource_grp_name
  dns_prefix          = "aksdemo"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_E8s_v5"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

 network_profile {
  network_plugin      = "azure"
  network_plugin_mode = "overlay"
  network_policy      = "azure"
  dns_service_ip      = "10.2.0.10"
  service_cidr        = "10.2.0.0/24"
  
}

  tags = {
    env = "dev"
  }
  depends_on = [ azurerm_resource_group.main ]
}


resource "azurerm_kubernetes_cluster_node_pool" "pool1" {
  name                  = "stateless1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 4
  min_count             = 4
  max_count             = 4
  mode                  = "User"
  os_type               = "Linux"
  vnet_subnet_id        =  azurerm_subnet.aks_subnet.id
  orchestrator_version  = azurerm_kubernetes_cluster.aks.kubernetes_version
  auto_scaling_enabled = true
  depends_on = [ azurerm_resource_group.main ]
}



resource "azurerm_kubernetes_cluster_node_pool" "pool2" {
  name                  = "stateless2"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 2
  min_count             = 2
  max_count             = 2
  mode                  = "User"
  os_type               = "Linux"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  orchestrator_version  = azurerm_kubernetes_cluster.aks.kubernetes_version
  auto_scaling_enabled = true
  depends_on = [ azurerm_subnet.aks_subnet ]
}


resource "azurerm_kubernetes_cluster_node_pool" "pool3" {
  name                  = "cascontoller"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_E8ds_v5"
  node_count            = 1
  min_count             = 1
  max_count             = 1
  mode                  = "User"
  os_type               = "Linux"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  orchestrator_version  = azurerm_kubernetes_cluster.aks.kubernetes_version
  auto_scaling_enabled = true
  depends_on = [ azurerm_subnet.aks_subnet ]
}



resource "azurerm_kubernetes_cluster_node_pool" "pool4" {
  name                  = "casworker"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_E16ds_v5"
  node_count            = 2
  min_count             = 2
  max_count             =  2
  mode                  = "User"
  os_type               = "Linux"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  orchestrator_version  = azurerm_kubernetes_cluster.aks.kubernetes_version
  auto_scaling_enabled = true
  depends_on = [ azurerm_subnet.aks_subnet ]
}

resource "azurerm_kubernetes_cluster_node_pool" "pool5" {
  name                  = "compute"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_L8s_v3"
  node_count            = 3
  min_count             =  1
  max_count             =  3
  mode                  = "User"
  os_type               = "Linux"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  orchestrator_version  = azurerm_kubernetes_cluster.aks.kubernetes_version
  auto_scaling_enabled = true
  depends_on = [ azurerm_subnet.aks_subnet ]
}


resource "azurerm_key_vault" "example" {
  name                        = var.key_vault_name
  location                    = var.location_of_akscluster
  resource_group_name         = var.resource_grp_name
  enabled_for_disk_encryption = true
  tenant_id                   = "105b2061-b669-4b31-92ac-24d304d195dc"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "105b2061-b669-4b31-92ac-24d304d195dc"
    object_id = "94fd0366-d1ba-41fb-a290-d2e2794690d1"

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  depends_on = [ azurerm_resource_group.main ]
}




resource "azurerm_container_registry" "acr" {
  name                = var.acrname # must be globally unique
  resource_group_name = var.resource_grp_name
  location            = var.location_of_akscluster
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    environment = "prod"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}




resource "azurerm_storage_account" "storageaccount1" {
  name                     = var.storage_account_name  # must be globally unique
  resource_group_name      = var.resource_grp_name
  location                 = var.location_of_akscluster
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Optional settings
  
  min_tls_version           = "TLS1_2"

  tags = {
    environment = "prod"
    
  }
  depends_on = [ azurerm_resource_group.main ]
}


resource "azurerm_storage_container" "container1" {
  name                  = "datacontainer"
  storage_account_name  = azurerm_storage_account.storageaccount1.name
  container_access_type = "private"  # options: private, blob, container
  depends_on = [ azurerm_storage_account.storageaccount1 ]
}


