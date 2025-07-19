variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_prefix" {
  description = "Address prefix for public subnet (jump box)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_prefix" {
  description = "Address prefix for private subnet (VMs)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "allowed_ssh_ips" {
  description = "List of IPs allowed to SSH to jump box"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Should be restricted in production
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}