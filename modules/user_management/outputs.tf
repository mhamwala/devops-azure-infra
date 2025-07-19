output "user_ssh_public_keys" {
  value = { for k, v in tls_private_key.user_ssh_keys : k => v.public_key_openssh }
  sensitive = true
}

output "user_passwords" {
  value = { for k, v in random_password.user_passwords : k => v.result }
  sensitive = true
}