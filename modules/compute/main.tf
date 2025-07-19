# Network Interfaces
resource "azurerm_network_interface" "vm_nic" {
  count               = var.vm_count
  name                = "${var.prefix}-vm${count.index + 1}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.prefix}-vm${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm_nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = base64encode(templatefile("${path.module}/scripts/mount_share.sh.tpl", {
    storage_account_name = var.storage_account_name
    storage_account_key  = var.storage_account_key
    file_share_name      = var.file_share_name
  }))

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}