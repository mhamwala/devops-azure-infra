variable "users" {
  description = "Map of users to create"
  type = map(object({
    user_principal_name = string
    display_name        = string
    mail_nickname       = string
  }))
}

variable "vm_ips" {
  description = "List of VM IPs for sudo configuration"
  type = list(string)
}

variable "admin_username" {
  description = "Admin username for VMs"
  type = string
}