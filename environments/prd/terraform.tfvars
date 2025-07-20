environment = "prd"
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
  allowed_ssh_ips       = ["xx.xx.xx.xxx/32"]
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
  account_replication_type = "LRS" # Locally Redundant Storage (cheapest)
  file_share_quota         = 5     # 5 GB for free tier
  enable_lifecycle_policy  = true
  archive_after_days       = 7
  delete_after_days        = 365
}

# User Management configuration
users = {
  user1 = {
    user_principal_name = "Isaac@musahamwalaicloud.onmicrosoft.com"
    display_name        = "Isaac Asimov"
    mail_nickname       = "Isaac"
  }
  user2 = {
    user_principal_name = "Adalovelace@musahamwalaicloud.onmicrosoft.com"
    display_name        = "Ada lovelace"
    mail_nickname       = "Ada"
  }
}

tags = {
  Environment = "prd"
  Project     = "azure-iac"
  ManagedBy   = "devops-team"
}