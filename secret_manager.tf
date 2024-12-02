# KMS key for Secrets Manager
resource "aws_kms_key" "secrets" {
  description         = "KMS key for Secrets Manager"
  enable_key_rotation = true
  policy              = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow Secrets Manager to use the key",
            "Effect": "Allow",
            "Principal": {
                "Service": "secretsmanager.amazonaws.com"
            },
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow EC2 Role to use the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.webapp_ec2_access_role.arn}"
            },
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow Lambda Role to use the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.lambda_exec_role.arn}"
            },
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Generate random names for secrets
resource "random_pet" "db_secret_name" {
  length    = 3
  separator = "-"
}

resource "random_pet" "api_secret_name" {
  length    = 3
  separator = "-"
}

# Create secret for database credentials
resource "aws_secretsmanager_secret" "db_secret" {
  name       = "db-credentials-${random_pet.db_secret_name.id}"
  kms_key_id = aws_kms_key.secrets.arn
}

# Create secret for API credentials
resource "aws_secretsmanager_secret" "api_secret" {
  name       = "api-credentials-${random_pet.api_secret_name.id}"
  kms_key_id = aws_kms_key.secrets.arn
}



# Create secret version for database credentials
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    password = aws_db_instance.database.password
  })
}

# Create secret version for API credentials
resource "aws_secretsmanager_secret_version" "api_secret_version" {
  secret_id = aws_secretsmanager_secret.api_secret.id
  secret_string = jsonencode({
    SENDGRID_API_KEY = var.sendgrid_api_key
  })
}

