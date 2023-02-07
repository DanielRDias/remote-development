resource "aws_instance" "dev" {
  count                  = var.destroy_instance ? 0 : 1
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.ec2_instance_type
  key_name               = module.key.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]
  user_data              = data.cloudinit_config.master.rendered
  subnet_id              = tolist(var.subnet_ids)[0]
  availability_zone      = var.az

  iam_instance_profile = aws_iam_instance_profile.profile.name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(var.default_tags, { Name = "remote-dev-${var.default_tags["Application"]}-${var.user_name}" })

}

module "key" {
  source = "./modules/key"
}

resource "aws_volume_attachment" "this_ec2" {
  count        = var.destroy_instance ? 0 : 1
  skip_destroy = true
  device_name  = var.data_volume
  volume_id    = aws_ebs_volume.this.id
  instance_id  = aws_instance.dev[0].id
}

resource "aws_ebs_volume" "this" {
  availability_zone = var.az
  size              = var.data_volume_size
  type              = "gp3"
  encrypted         = true


  tags = {
    Name    = "remote-dev-${var.default_tags["Application"]}-${var.user_name}"
    Purpose = "remote-development-data"
  }
}
