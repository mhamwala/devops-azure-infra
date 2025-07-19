resource "azurerm_resource_group" "main" {
  name     = "${var.project.name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source                = "./modules/networking"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  prefix                = var.project.name
  environment           = var.environment
  vnet_address_space    = var.networking.vnet_address_space
  public_subnet_prefix  = var.networking.public_subnet_prefix
  private_subnet_prefix = var.networking.private_subnet_prefix
  allowed_ssh_ips       = var.networking.allowed_ssh_ips
  tags                  = var.tags
}

# compute Module
module "compute" {
  source              = "./modules/compute"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.project.name
  subnet_id           = module.networking.private_subnet_id
  vm_count            = var.compute.vm_count       
  vm_size             = var.compute.vm_size       
  admin_username      = var.compute.admin_username
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
}

# Storage Module
module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.project.name
  environment         = var.environment
  tags                = var.tags
}