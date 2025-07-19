resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_storage_account" "main" {
  name                     = "stor${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  
  # Enable encryption
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
  }
  
  # Security settings
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  
  tags = var.tags
}

# Blob Container
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# File Share for VM mounting
resource "azurerm_storage_share" "vm_share" {
  name                 = "vmshare"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 5  # 5GB for free tier
}

# Lifecycle Management Policy
resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.main.id
  
  rule {
    name    = "archiveanddelete"
    enabled = true
    
    filters {
      blob_types = ["blockBlob"]
    }
    
    actions {
      base_blob {
        # Move to Archive tier after 7 days
        tier_to_archive_after_days_since_modification_greater_than = 7
        # Delete after 365 days
        delete_after_days_since_modification_greater_than = 365
      }
      
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
}