resource "azurerm_netapp_account" "anf_account" {
  name                = "myanfaccount"
  location            = var.location_of_akscluster
  resource_group_name = var.resource_grp_name
  depends_on = [ azurerm_resource_group.main ]
}

resource "azurerm_netapp_pool" "anf_pool" {
  name                = "anfpool01"
  location            = var.location_of_akscluster
  resource_group_name = var.resource_grp_name
  account_name        = azurerm_netapp_account.anf_account.name

  service_level       = "Standard"
  size_in_tb          = 4

  depends_on = [
    azurerm_netapp_account.anf_account
  ]
}

resource "azurerm_netapp_volume" "example" {
  name                       = "example-netappvolume"
  location                   = var.location_of_akscluster
  zone                       = "1"
  resource_group_name        = var.resource_grp_name
  account_name               = azurerm_netapp_account.anf_account.name
  pool_name                  = azurerm_netapp_pool.anf_pool.name
  volume_path                = "my-unique-file-path"
  service_level              = "Standard"
  subnet_id                  = azurerm_subnet.anf_subnet.id
  protocols                  = ["NFSv4.1"]
  security_style             = "unix"
  storage_quota_in_gb        = 100
  snapshot_directory_visible = false

  export_policy_rule {
    rule_index        = 1
    allowed_clients   = ["0.0.0.0/0"]
    protocols_enabled = ["NFSv4.1"]
    unix_read_only    = false
    unix_read_write   = true
  }

   lifecycle {
    prevent_destroy = false   # as in testing phase make sure its true in prod 
  }

  depends_on = [
    azurerm_netapp_pool.anf_pool,
    azurerm_netapp_account.anf_account,
    azurerm_subnet.anf_subnet
  ]
}





