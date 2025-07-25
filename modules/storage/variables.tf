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
  default     = "dev"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "account_tier" {
  description = "The storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The storage account replication type"
  type        = string
  default     = "LRS"
}

variable "file_share_quota" {
  description = "Quota for the file share in GB"
  type        = number
  default     = 5
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle management policy"
  type        = bool
  default     = true
}

variable "archive_after_days" {
  description = "Days after which to archive blobs"
  type        = number
  default     = 7
}

variable "delete_after_days" {
  description = "Days after which to delete blobs"
  type        = number
  default     = 365
}