resource "random_string" "id" {
  length  = 5
  special = false
}

resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "remote_dev_${random_string.id.result}"
  public_key = tls_private_key.generated_key.public_key_openssh
}

output "generated_key_name" {
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
