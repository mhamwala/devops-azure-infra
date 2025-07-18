environment = "dev"
location    = "UK South"

project = {
  name        = "devops-test"
  cost_center = "devops"
  owner       = "devops-team"
}

networking = {
  vnet_address_space    = ["10.0.0.0/16"]
  public_subnet_prefix  = "10.0.1.0/24"
  private_subnet_prefix = "10.0.2.0/24"
  allowed_ssh_ips      = ["86.26.32.247/32"]
}

compute = {
  vm_count       = 2
  vm_size        = "Standard_B1s"
  admin_username = "azureuser"
  ssh_public_key = ""
}

tags = {
  Environment = "dev"
  Project     = "azure-iac"
  ManagedBy   = ""
}