resource "tls_private_key" "generated_key" {
  count = var.ssh_public_key != "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name_prefix   = "remote-dev-${var.default_tags["Application"]}-${var.user_name}"
  public_key = var.ssh_public_key != "" ? var.ssh_public_key : tls_private_key.generated_key.public_key_openssh
}
