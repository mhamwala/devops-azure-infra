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

# User Management Module
module "user_management" {
  source           = "./modules/user_management"
  users            = var.users
  vm_ips           = module.compute.vm_private_ips
  admin_username   = var.compute.admin_username
}

# Jump Box VM in Public Subnet
resource "azurerm_public_ip" "jumpbox" {
  name                = "${var.project.name}-${var.environment}-jumpbox-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "${var.project.name}-${var.environment}-jumpbox-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.networking.public_subnet_id  # From networking module
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = "${var.project.name}-${var.environment}-jumpbox"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.compute.vm_size  # Use same size as private VMs (B1s for free tier)

  admin_username = var.compute.admin_username

  admin_ssh_key {
    username   = var.compute.admin_username
    public_key = file("~/.ssh/id_rsa.pub")  # Same key as private VMs
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # TO DO: Add custom_data for file share mounting if needed (from storage module)
  # custom_data = base64encode(templatefile("${path.module}/mount_share.sh.tpl", {
  #   storage_account_name = module.storage.storage_account_name
  #   file_share_name      = "myshare"
  #   storage_account_key  = module.storage.storage_account_key
  # }))

  tags = var.tags
}