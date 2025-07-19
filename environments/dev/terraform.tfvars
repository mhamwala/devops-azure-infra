environment = "dev"
location    = "UK South"

project = {
  name        = "devops-azure-exercise"
  cost_center = "devops"
  owner       = "devops-team"
}

# Networking configuration
networking = {
    vnet_address_space    = ["10.0.0.0/16"]
    public_subnet_prefix  = "10.0.1.0/24"
    private_subnet_prefix = "10.0.2.0/24"
    allowed_ssh_ips       = ["86.26.32.247/32"]
}

# VM configuration
compute = {
  vm_count       = 2
  vm_size        = "Standard_B1s"
  admin_username = "azureuser"
  ssh_public_key = ""
}

# Storage Account configuration
storage = {
  account_tier             = "Standard"
  account_replication_type = "LRS"  # Locally Redundant Storage (cheapest)
  file_share_quota         = 5      # 5 GB for free tier
  enable_lifecycle_policy  = true
  archive_after_days       = 7
  delete_after_days        = 365
}

# User Management configuration
users = {
  user1 = {
    user_principal_name = "user1@devopstest.com"
    display_name        = "User One"
    mail_nickname       = "user1"
  }
  user2 = {
    user_principal_name = "user2@devopstest.com"
    display_name        = "User Two"
    mail_nickname       = "user2"
  }
}

tags = {
  Environment = "dev"
  Project     = "azure-iac"
  ManagedBy   = "devops-team"
}