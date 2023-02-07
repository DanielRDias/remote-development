resource "aws_cloudwatch_log_group" "cwlgroup" {

  name              = "remote-dev-${var.application}-${var.user_name}"
  retention_in_days = 30

  kms_key_id        = aws_kms_key.kms_key.arn

  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}

resource "aws_kms_key" "kms_key" {
  description         = "remote-dev-${var.application}-${var.user_name}"
  enable_key_rotation = true

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.${var.region}.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
     ],
      "Resource": "*",
      "Condition": {
        "ArnLike": {
          "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
        }
      }
    }
  ]
}
EOF

  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}
