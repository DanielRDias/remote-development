resource "aws_cloudwatch_event_rule" "lambda_start_instance" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  name = "${aws_lambda_function.lambda_instance[0].function_name}-start"
  description = "START - Triggers lambda function ${aws_lambda_function.lambda_instance[0].function_name}"

  schedule_expression  = var.start_time


  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}

resource "aws_cloudwatch_event_target" "lambda_start_instance" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  rule      = aws_cloudwatch_event_rule.lambda_start_instance[0].name
  target_id = aws_lambda_function.lambda_instance[0].function_name
  arn       = aws_lambda_function.lambda_instance[0].arn

  input = <<EOF
{
  "action": "START_INSTANCE"
}
EOF
}

resource "aws_cloudwatch_event_rule" "lambda_stop_instance" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  name = "${aws_lambda_function.lambda_instance[0].function_name}-stop"
  description = "STOP - Triggers lambda function ${aws_lambda_function.lambda_instance[0].function_name}"

  schedule_expression  = var.stop_time


  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}

resource "aws_cloudwatch_event_target" "lambda_stop_instance" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  rule      = aws_cloudwatch_event_rule.lambda_stop_instance[0].name
  target_id = aws_lambda_function.lambda_instance[0].function_name
  arn       = aws_lambda_function.lambda_instance[0].arn

  input = <<EOF
{
  "action": "STOP_INSTANCE"
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  name = "remote-dev-${var.application}-${var.user_name}-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  name = "remote-dev-${var.application}-${var.user_name}"
  role = aws_iam_role.lambda_role[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstanceStatus",
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "${local.email_sns_topic_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "lambda_instance" {
  count        = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_instance[0].function_name
  principal     = "events.amazonaws.com"
}

resource "aws_lambda_function" "lambda_instance" {
  count = (var.enable_scheduler && !var.destroy_instance) ? 1 : 0

  filename      = "${path.module}/${local.lambda_function_archive}"
  function_name = "remote-dev-${var.application}-${var.user_name}"
  role          = aws_iam_role.lambda_role[0].arn
  handler       = "lambda_function.handler"
  runtime       = "python3.9"
  architectures = ["arm64"]
  timeout       = 60
  memory_size   = 128

  source_code_hash = fileexists("${path.module}/${local.lambda_function_archive}") ? filebase64sha256("${path.module}/${local.lambda_function_archive}") : null

  environment {
    variables = {
      INSTANCE = aws_instance.dev[0].id
      REGION   = var.region
      RECIPIENT = var.GIT_EMAIL
      EMAIL_SNS_TOPIC_ARN = local.email_sns_topic_arn
    }
  }

  tags = {
    Name = "remote-dev-${var.application}-${var.user_name}"
  }
}
