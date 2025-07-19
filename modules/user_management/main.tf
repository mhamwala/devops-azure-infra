resource "azuread_user" "users" {
  for_each = var.users

  user_principal_name = each.value.user_principal_name
  display_name        = each.value.display_name
  mail_nickname       = each.value.mail_nickname
  password            = random_password.user_passwords[each.key].result
  account_enabled     = true
}

resource "tls_private_key" "user_ssh_keys" {
  for_each = var.users

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "user_ssh_private_keys" {
  for_each = var.users

  content         = tls_private_key.user_ssh_keys[each.key].private_key_pem
  filename        = "${path.module}/${each.key}-ssh-key.pem"
  file_permission = "0600"
}

resource "random_password" "user_passwords" {
  for_each = var.users

  length           = 16
  special          = true
  override_special = "!@#$%"
}
