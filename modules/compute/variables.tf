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

variable "subnet_id" {
  description = "ID of the subnet for VMs"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Name of the storage account for mounting"
  type        = string
}

variable "storage_account_key" {
  description = "Key of the storage account for mounting"
  type        = string
  sensitive   = true
}

variable "file_share_name" {
  description = "Name of the file share to mount"
  type        = string
}