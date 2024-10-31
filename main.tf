# Security Group for EC2 hosting the web application
resource "aws_security_group" "application-security-group" {
  name        = "application-security-group"
  description = "Security group for web application EC2 instances"
  vpc_id      = aws_vpc.dev_vpc.id

  # Allow SSH access (port 22)
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  # Allow HTTP traffic (port 80)
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  # Allow HTTPS traffic (port 443)
  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  # Allow application traffic on port 3000
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = var.tcp_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }


  tags = {
    Name = "application-security-group"
  }
}


resource "aws_instance" "web_app_ec2" {
  ami                    = var.custom_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.application-security-group.id]
  subnet_id              = aws_subnet.public[0].id
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_profile.name

  user_data = <<-EOF
              #!/bin/bash
              cd /home/csye-6225/webapp/webapp
              touch .env
              echo "PORT=3000" >> .env
              echo "DB_HOST=${aws_db_instance.database.address}" >> .env
              echo "DB_NAME=${aws_db_instance.database.db_name}" >> .env
              echo "DB_USERNAME=${aws_db_instance.database.username}" >> .env
              echo "DB_PASSWORD=${aws_db_instance.database.password}" >> .env
              echo "DB_DIALECT=${var.db_dialect}" >> .env
              echo "AWS_REGION=${var.aws_region}" >> .env
              echo "AWS_BUCKET_NAME=${aws_s3_bucket.bucket.bucket}" >> .env
              sudo systemctl enable startup.service
              sudo systemctl start startup.service

              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
              -a fetch-config \
              -m ec2 \
              -c file:/opt/cloudwatch-config.json \
              -s
              EOF

  disable_api_termination = false

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = true
  }

  tags = {
    Name = "web-app-instance"
  }
}


# Define a local variable for the EC2 public IP
locals {
  ec2_public_ip = aws_instance.web_app_ec2.public_ip
}

resource "aws_iam_policy" "webapp_s3_policy" {
  name        = "WebappS3Policy"
  path        = var.s3_policy_path
  description = "Allow webapp s3 access"

  policy = jsonencode({
    Version : var.s3_policy_version,
    Statement : [
      {
        "Action" : [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Effect" : var.s3_policy_effect,
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"
        ]
      }
    ]
  })

  tags = {
    Name = "WebAppS3Policy"
  }
}

resource "aws_iam_role" "webapp_ec2_access_role" {
  name = "EC2-WEBAPP-CSYE-6225"

  assume_role_policy = jsonencode({
    Version = var.s3_policy_version,
    Statement = [
      {
        Action = var.s3_policy_action,
        Effect = var.s3_policy_effect,
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "EC2-WEBAPP-CSYE-6225"
  }
}

data "aws_iam_policy" "webapp_cloudwatch_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy_attachment" "ec2_s3_policy_role" {
  name       = "webapp_s3_attachment"
  roles      = [aws_iam_role.webapp_ec2_access_role.name]
  policy_arn = aws_iam_policy.webapp_s3_policy.arn
}

resource "aws_iam_policy_attachment" "ec2_cloudwatch_policy_role" {
  name       = "webapp_cloudwatch_policy_attachment"
  roles      = [aws_iam_role.webapp_ec2_access_role.name]
  policy_arn = data.aws_iam_policy.webapp_cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "webapp_ec2_profile"
  role = aws_iam_role.webapp_ec2_access_role.name
}

# Output the EC2 public IP for reference
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = local.ec2_public_ip
}
