resource "azurerm_resource_group" "main" {
  name     = "${var.project.name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.project.name}-${var.environment}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.networking.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.networking.private_subnet_prefix]
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.project.name
  subnet_id           = azurerm_subnet.internal.id
  vm_count            = var.compute.vm_count       
  vm_size             = var.compute.vm_size       
  admin_username      = var.compute.admin_username
  ssh_public_key      = var.compute.ssh_public_key
}