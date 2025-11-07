module "resource_group" {
  source = "../modules/azurerm_rg"
  rgs    = var.rgs
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_vnet"
  vnets      = var.vnets
}
module "public_ip" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_public_ip"
  pips       = var.pips
}

module "kv" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_key_vault"
  keys       = var.keys
}

module "secret" {
  depends_on = [module.kv]
  source     = "../modules/azurerm_kv_secret"
  secrets    = var.secrets
}

module "nsg" {
  depends_on = [ module.resource_group, module.virtual_network ]
  source = "../modules/azurerm_nsg"
  nsgs = var.nsgs
  
}
module "vm" {
  depends_on = [module.resource_group, module.public_ip, module.virtual_network, module.kv, module.secret]
  source     = "../modules/azurerm_vm"
  vms        = var.vms
}