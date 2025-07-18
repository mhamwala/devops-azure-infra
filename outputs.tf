output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_private_ips" {
  value = module.compute.vm_private_ips
}

output "vm_names" {
  value = module.compute.vm_names
}