# SNS Topic
resource "aws_sns_topic" "notification_topic" {
  name = "lambda-serverless-topic"

  tags = {
    Name = "SNS Lambda Notification Topic"
  }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda Policy
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "sns:Subscribe",
          "sns:Receive"
        ]
        Effect   = "Allow"
        Resource = aws_sns_topic.notification_topic.arn
      },
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:CreateNetworkInterfacePermission"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*"
        Condition = {
          StringEquals = {
            "ec2:AuthorizedService" = "lambda.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Add policy to Lambda role to access API secret
resource "aws_iam_role_policy" "lambda_secrets_policy" {
  name = "lambda-secrets-policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [aws_secretsmanager_secret.api_secret.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = [aws_kms_key.secrets.arn]
      }
    ]
  })
}

# Attach Lambda Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Additional policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "serverless_function" {
  function_name = "serverless-email-handler"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 30
  memory_size   = 128
  filename      = var.lambda_file_path

  # Place Lambda in a public subnet
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id # Use private subnets
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      VERIFICATION_URL = var.verification_url
      API_SECRET_NAME  = aws_secretsmanager_secret.api_secret.name
    }
  }

  source_code_hash = filebase64sha256(var.lambda_file_path)

  tags = {
    Name = "serverless-lambda"
  }
}

# Security Group for Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Allow Lambda outbound access"
  vpc_id      = aws_vpc.dev_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name = "Lambda Security Group"
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
