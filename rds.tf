resource "random_password" "password" {
  length  = 16
  special = false
}
#kms key for RDS
resource "aws_kms_key" "rds" {
  description              = "RDS KMS key"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  multi_region             = true
  policy = jsonencode(

    {
      "Id" : "key-for-rds",
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Enable IAM User Permissions",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
          },
          "Action" : "kms:*",
          "Resource" : "*"
        },
        {
          "Sid" : "Allow use of the key",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
          },
          "Action" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "Allow attachment of persistent resources",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
          },
          "Action" : [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
          ],
          "Resource" : "*",
          "Condition" : {
            "Bool" : {
              "kms:GrantIsForAWSResource" : "true"
            }
          }
        }
      ]
    }

  )
}

# Security Group for RDS Database
resource "aws_security_group" "database" {
  name        = "database"
  description = "Security group for MySQL RDS instance"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.webapp_sg.id]
  }

  # No egress rule - restrict access to the internet

  tags = {
    Name = "database"
  }
}


resource "aws_db_parameter_group" "mysql_parameter_group" {
  name        = var.mysql_parameter_group
  family      = var.pg_family
  description = "Custom MySQL parameter group A05"

  tags = {
    Name = "mysql-parameter-group"
  }
}

# Create Subnet Group for RDS (Using Private Subnets)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group
  subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  tags = {
    Name = "rds-private-subnet-group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "database" {
  identifier              = var.identifier_rds
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.username
  password                = random_password.password.result
  parameter_group_name    = aws_db_parameter_group.mysql_parameter_group.name
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  multi_az                = false
  publicly_accessible     = false
  storage_encrypted       = true
  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true
  kms_key_id              = aws_kms_key.rds.arn

  tags = {
    Name = "csye6225-mysql-instance"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.database.endpoint
}
