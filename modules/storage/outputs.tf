output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "storage_connection_string" {
  description = "Connection string for the storage account"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "file_share_name" {
  description = "Name of the file share"
  value       = azurerm_storage_share.vm_share.name
}

output "file_share_url" {
  description = "URL of the file share"
  value       = azurerm_storage_share.vm_share.url
}

output "blob_container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.data.name
}

# Useful output for mounting
output "mount_command" {
  description = "Command to mount the file share on Linux"
  value       = <<-EOT
    sudo mkdir -p /mnt/azurefiles
    sudo mount -t cifs //${azurerm_storage_account.main.name}.file.core.windows.net/${azurerm_storage_share.vm_share.name} /mnt/azurefiles -o credentials=/etc/smbcredentials/${azurerm_storage_account.main.name}.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
  EOT
}