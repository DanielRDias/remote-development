data "aws_ami" "this" {
  # https://wiki.centos.org/Cloud/AWS
  # The current official AMIs are published outside of the AWS Marketplace and are shared directly from official CPE account 125523088429.
  owners = ["125523088429"]

  most_recent = true

  # It would be better to filter by platform, but currently, platform value is Windows for Windows AMIs; otherwise, blank.
  filter {
    name   = "name"
    values = ["CentOS*${var.os_version}*${var.arch}*"]
  }

}
