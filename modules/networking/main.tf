# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.tags
}

# Public Subnet (for Jump Box)
resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_prefix]

  service_endpoints = ["Microsoft.Storage"]
}

# Private Subnet (for VMs)
resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_prefix]

  service_endpoints = ["Microsoft.Storage"]
}

# Network Security Group for Jump Box
resource "azurerm_network_security_group" "jump_box" {
  name                = "${var.prefix}-${var.environment}-jump-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# NSG Rule for SSH to Jump Box
resource "azurerm_network_security_rule" "jump_ssh" {
  name                        = "AllowSSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_ssh_ips
  destination_address_prefix  = var.public_subnet_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.jump_box.name
}

# Network Security Group for Private VMs
resource "azurerm_network_security_group" "private_vms" {
  name                = "${var.prefix}-${var.environment}-private-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# NSG Rule for SSH from Jump Box to Private VMs
resource "azurerm_network_security_rule" "private_ssh_from_jump" {
  name                        = "AllowSSHFromJumpBox"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.public_subnet_prefix
  destination_address_prefix  = var.private_subnet_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_vms.name
}

# NSG Rule for Storage Access
resource "azurerm_network_security_rule" "storage_outbound" {
  name                        = "AllowStorageOutbound"
  priority                    = 1002
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = var.private_subnet_prefix
  destination_address_prefix  = "Storage"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_vms.name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.jump_box.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private_vms.id
}