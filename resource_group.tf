resource "aws_resourcegroups_group" "group" {
  name = "remote-dev-${var.user_name}"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": ["AWS::AllSupported"],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": [
        "remote-dev-${var.default_tags["Application"]}-${var.user_name}",
        "remote-dev-${var.application}-${var.user_name}",
        "remote-dev-${var.application}-${var.user_name}-ec2",
        "remote-dev-${var.application}-${var.user_name}-lambda",
        "DLM-BackupRole-${var.application}-${var.user_name}",
        "DLM-BackupPolicy-${var.application}-${var.user_name}"
      ]
    }
  ]
}
JSON
  }

  tags = {
    Name = "remote-dev-${var.default_tags["Application"]}-${var.user_name}"
  }
}