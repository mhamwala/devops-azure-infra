output "vm_private_ips" {
  description = "Private IP addresses of the VMs"
  value       = azurerm_network_interface.vm_nic[*].private_ip_address
}

output "vm_names" {
  description = "Names of the VMs"
  value       = azurerm_linux_virtual_machine.vm[*].name
}

output "vm_ids" {
  description = "Resource IDs of the VMs"
  value       = azurerm_linux_virtual_machine.vm[*].id
}

output "nic_ids" {
  description = "Network interface IDs"
  value       = azurerm_network_interface.vm_nic[*].id
}