variable "project" {
  description = "Project configuration"
  type = object({
    name        = string
    cost_center = string
    owner       = string
  })
  default = {
    name        = "devops-azure-exercise"
    cost_center = "devops"
    owner       = "devops-team"
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}

variable "networking" {
  description = "Networking configuration"
  type = object({
    vnet_address_space    = list(string)
    public_subnet_prefix  = string
    private_subnet_prefix = string
    allowed_ssh_ips       = list(string)
  })
  # default = {
  #   vnet_address_space    = ["10.0.0.0/16"]
  #   public_subnet_prefix  = "10.0.1.0/24"
  #   private_subnet_prefix = "10.0.2.0/24"
  #   allowed_ssh_ips       = ["86.26.32.247/32"]
  # }
}

variable "compute" {
  description = "Compute configuration"
  type = object({
    vm_count       = number
    vm_size        = string
    admin_username = string
    ssh_public_key = string
  })
  default = {
    vm_count       = 2
    vm_size        = "Standard_B1s"
    admin_username = "azureuser"
    ssh_public_key = ""
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "azure-iac"
    ManagedBy   = "devops-team"
  }
}

