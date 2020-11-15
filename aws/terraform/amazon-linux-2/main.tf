module "ec2_remote_development" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"
  name                   = "remote_dev_${random_string.id.result}"
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]
  subnet_id              = var.subnet_id
}

output "public-ip" {
  description = "EC2 public IP"
  value       = module.ec2_remote_development.public_ip
}

output "private-ip" {
  description = "EC2 private IP"
  value       = module.ec2_remote_development.private_ip
}
