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