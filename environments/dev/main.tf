module "resource_group" {
  source = "../../modules/azurerm_rg"
  rgs    = var.rgs
}

module "vnet" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_vnet"
  vnets      = var.vnets
}
module "public_ip" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_public_ip"
  pips       = var.pips
}

module "kv" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_key_vault"
  keys       = var.keys
}

module "secret" {
  depends_on = [module.kv]
  source     = "../../modules/azurerm_kv_secret"
  secrets    = var.secrets
}

module "nsg" {
  depends_on = [ module.resource_group, module.vnet ]
  source = "../../modules/azurerm_nsg"
  nsgs = var.nsgs
  
}
module "vm" {
  depends_on = [module.resource_group, module.public_ip, module.vnet, module.kv, module.secret]
  source     = "../../modules/azurerm_vm"
  vms        = var.vms
}

module "server" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_mssql_server"
  servers = var.servers
  
}

module "database" {
  depends_on = [ module.resource_group, module.server ]
  source = "../../modules/azurerm_mssql_database"
  databases = var.databases
  
}

module "stg" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_storage_account"
  stgs = var.stgs
  
}

module "acr" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_acr"
  acrs = var.acrs
  
}

module "aks" {
    depends_on = [ module.resource_group ]
    source = "../../modules/azurerm_aks"
    aks = var.aks
  
}