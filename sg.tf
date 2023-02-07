resource "aws_security_group" "ssh" {
  name        = "allow_ssh_remote-dev-${var.application}-${var.user_name}"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.access_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id

  tags = {
    Name = "remote-dev-${var.default_tags["Application"]}-${var.user_name}"
  }
}
