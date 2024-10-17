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


  tags = {
    Name = "application-security-group"
  }
}

# EC2 Instance Resource
resource "aws_instance" "web_app_ec2" {
  ami                    = var.custom_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.application-security-group.id]
  subnet_id              = aws_subnet.public[0].id

  # Disable accidental termination protection
  disable_api_termination = false

  # Terminate EBS volume when the instance is terminated
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = true
  }

  tags = {
    Name = "web-app-instance"
  }
}

# Output the EC2 public IP
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web_app_ec2.public_ip
}
