output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_private_ips" {
  value = module.compute.vm_private_ips
}

output "vm_names" {
  value = module.compute.vm_names
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "file_share_name" {
  value = module.storage.file_share_name
}

# output "storage_mount_instructions" {
#   value = <<-EOT
#     To mount the storage on your VMs:
    
#     1. SSH into the VM
#     2. Create credentials file:
#        sudo mkdir -p /etc/smbcredentials
#        sudo nano /etc/smbcredentials/${module.storage.storage_account_name}.cred
       
#        Add these lines:
#        username=${module.storage.storage_account_name}
#        password=${module.storage.storage_account_key}
       
#     3. Secure the file:
#        sudo chmod 600 /etc/smbcredentials/${module.storage.storage_account_name}.cred
       
#     4. Mount the share:
#        ${module.storage.mount_command}
#   EOT
#   sensitive = true
# }