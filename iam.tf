resource "aws_iam_role" "role" {
  name        = "remote-dev-${var.application}-${var.user_name}-ec2"
  description = "Instance remote-dev-${var.application}-${var.user_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}

resource "aws_iam_instance_profile" "profile" {
  name = "remote-dev-${var.application}-${var.user_name}"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "attachment1" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "attachment2" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
