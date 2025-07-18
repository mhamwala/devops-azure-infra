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
    allowed_ssh_ips      = list(string)
  })
  default = {
    vnet_address_space    = ["10.0.0.0/16"]
    public_subnet_prefix  = "10.0.1.0/24"
    private_subnet_prefix = "10.0.2.0/24"
    allowed_ssh_ips      = []
  }
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
    ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6KutqntDsiJ78cpCNeWVTNKvwA9IQXh8Vcrx2o+p1zvMI7lUge6ASJc1AHZjIFyXGMexxXD59P853ZdyaXvpDVCc91blo0UpsVcjaJZw+a7tzA60TKU17Pk9IxUMZOviORUnqIVBhlcWj7miKxycKO+bn0lt9Gz3Knu1Pcdc/uwz1chZstIGVVRHlfTJpJgJWQQyZXGYwOviMspbqqmv+8WGleQa9c4pKkquhK1+SIJ7taVX/Fsm62h4o5XOC8uNmUS0qyBcwaEggHbY7cZ7axAPoac9QKCdzZOnl8S5HXe92ZFoMvbbt9lVlOX0mA+XhiVass/ndkq2bBoyFNxM5Kg+Off6NJgYf2vb7gFH8u2gsrgAJRg4Xf/EIygtcsmkLEteDyYPEN4mwNOYxcQfdsT20EpEMcNA8QHAYqEqrlaAM8GpJ1pYaxf4hALgyws9lyX+anKxAiXc/CGtEIzLvb1nUUtchmASrOma49BlbbeB/dChvKgtPR6/KMMPvETVuTJzRov9011XBwOKwIMctHlGsuS4KHaf+1DwCPLOoDP/zGosOAe1o92B7cn3KticeQWI3Hdo+Gjg8eoEb6xtFDc/dGfcH2ex5vHgGQd9i8x9uOlw3qVv+paAcboDSNd36M5D1QLrhCxNSdrAPzd5JwGzIKPtUWmfOz9Z2Ub67zw== musahamwala@Musas-MacBook-Pro.local"
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