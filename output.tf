output "key_name" {
  description = "Generated key name"
  value       = module.key.key_name
}

output "private_key_pem" {
  description = "SSH private pem key"
  value       = module.key.private_key_pem
}

output "public_key_pem" {
  description = "SSH public pem key"
  value       = module.key.public_key_pem
}

output "public_key_openssh" {
  description = "Open SSH public key"
  value       = module.key.public_key_openssh
}


output "public-ip" {
  description = "EC2 public IP"
  value       = module.ec2_remote_development.public_ip
}

output "private-ip" {
  description = "EC2 private IP"
  value       = module.ec2_remote_development.private_ip
}
