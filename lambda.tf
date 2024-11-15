# SNS Topic
resource "aws_sns_topic" "notification_topic" {
  name = "lambda-serverless-topic"

  tags = {
    Name = "SNS Lambda Notification Topic"
  }
}

# Security Group for Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Security group for Lambda function"
  vpc_id      = aws_vpc.dev_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}

# Security Group Rule for Lambda to RDS
resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = var.tcp_protocol
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.lambda_sg.id
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

# Lambda Policy
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Action": [
        "sns:Publish",
        "rds:DescribeDBInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


# Attach Lambda Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "serverless_function" {
  function_name = "serverless-handler"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 30
  memory_size   = 128
  filename      = "./function.zip"

  environment {
    variables = {
      SENDGRID_API_KEY = var.sendgrid_api_key
      VERIFICATION_URL = var.verification_url
      DB_HOST          = aws_db_instance.database.endpoint
      DB_PORT          = var.db_port
      DB_NAME          = var.db_name
      DB_USERNAME      = var.username
      DB_PASSWORD      = var.db_password
      DB_DIALECT       = var.db_dialect
    }
  }

  source_code_hash = filebase64sha256("./function.zip")

  vpc_config {
    subnet_ids         = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Name = "serverless-lambda"
  }
}

# SNS Subscription
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.serverless_function.arn

  depends_on = [aws_lambda_permission.allow_sns_to_invoke]
}

# Permission for SNS to invoke Lambda
resource "aws_lambda_permission" "allow_sns_to_invoke" {
  statement_id  = "AllowSNSTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.serverless_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification_topic.arn
}
