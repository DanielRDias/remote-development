
output "key_name" {
  description = "Generated key name"
  value       = aws_key_pair.generated_key.key_name
}

output "private_key_pem" {
  description = "SSH private pem key"
  value       = tls_private_key.generated_key.private_key_pem
}

output "public_key_pem" {
  description = "SSH public pem key"
  value       = tls_private_key.generated_key.public_key_pem
}

output "public_key_openssh" {
  description = "Open SSH public key"
  value       = tls_private_key.generated_key.public_key_openssh
}
