data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2022-ami-kernel-default-x86_64"
}

data "aws_caller_identity" "current" {}

