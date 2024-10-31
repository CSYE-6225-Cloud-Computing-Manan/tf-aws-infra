variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
}

variable "vpc_name" {
  description = "tag Name for the VPC"
  type        = string
}

variable "igw_name" {
  description = "tag Name for the Internet Gateway"
  type        = string
}

variable "internet_cidr" {
  description = "tag Name for the Internet CIDR"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "private_route_table" {
  description = "Name of private route table"
  type        = string
}

variable "public_route_table" {
  description = "Name of public route table"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "ssh_port" {
  description = "The SSH port"
  type        = number
}

variable "http_port" {
  description = "The HTTP port"
  type        = number
}

variable "https_port" {
  description = "The HTTPS port"
  type        = number
}

variable "app_port" {
  description = "The application port"
  type        = number
}

variable "tcp_protocol" {
  description = "The TCP protocol"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow ingress traffic"
  type        = list(string)
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks to allow egress traffic"
  type        = list(string)
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "custom_ami" {
  description = "The custom AMI ID"
  type        = string
}

variable "volume_size" {
  description = "The volume size"
  type        = number
}

variable "volume_type" {
  description = "The volume type"
  type        = string
}


variable "db_port" {
  description = "The port for the RDS instance"
  type        = number
}

variable "pg_family" {
  description = "The family for the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage for the RDS instance"
  type        = number
}

variable "engine" {
  description = "The engine for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "The engine version for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "username" {
  description = "The username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
}

variable "db_dialect" {
  description = "The dialect for the RDS instance"
  type        = string
}

variable "backup_retention_period" {
  description = "The backup retention period for the RDS instance"
  type        = number
}

variable "identifier_rds" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the Route 53 zone"
  type        = string
}

variable "subdomain" {
  description = "The subdomain (dev or demo) to use for the Route 53 record"
  type        = string
}




