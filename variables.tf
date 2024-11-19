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

variable "s3_policy_path" {
  description = "The path for the S3 policy"
  type        = string
}

variable "s3_policy_version" {
  description = "The version for the S3 policy"
  type        = string
}

variable "s3_policy_effect" {
  description = "The effect for the S3 policy"
  type        = string
}

variable "s3_policy_action" {
  description = "The action for the S3 policy"
  type        = string
}

variable "storage_class" {
  description = "The storage class for the S3 bucket"
  type        = string
}

variable "s3_encryption_algorithm" {
  description = "The encryption algorithm for the S3 bucket"
  type        = string
}

variable "s3_rule_id" {
  description = "The ID for the S3 rule"
  type        = string
}

variable "s3_rule_status" {
  description = "The status for the S3 rule"
  type        = string
}

variable "aws_public_key" {
  description = "The public key for the EC2 instance"
  type        = string
}

variable "mysql_parameter_group" {
  description = "The name of the MySQL parameter group"
  type        = string
}

variable "db_subnet_group" {
  description = "The name of the RDS subnet group"
  type        = string
}

variable "load_balancer_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "load_balancer_type" {
  description = "The type of load balancer"
  type        = string
}

variable "tg_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_type" {
  description = "The target type for the target group"
  type        = string
}

variable "http_protocol" {
  description = "The HTTP protocol"
  type        = string
}

variable "health_check_path" {
  description = "The path for the health check"
  type        = string
}

variable "health_check_port" {
  description = "The port for the health check"
  type        = string
}

variable "lb_listener_type" {
  description = "The type of listener for the load balancer"
  type        = string
}

variable "asg_name" {
  description = "The name of the auto scaling group"
  type        = string
}

variable "asg_min_size" {
  description = "The minimum size for the auto scaling group"
  type        = number
}

variable "asg_max_size" {
  description = "The maximum size for the auto scaling group"
  type        = number
}

variable "asg_desired_capacity" {
  description = "The desired capacity for the auto scaling group"
  type        = number
}

variable "asg_default_cooldown" {
  description = "The default cooldown for the auto scaling group"
  type        = number
}

variable "asg_scale_out_name" {
  description = "The name of the scale out policy"
  type        = string
}

variable "adjustment_type" {
  description = "The adjustment type for the auto scaling policy"
  type        = string
}

variable "metric_name" {
  description = "The metric name for the cloudwatch alarm"
  type        = string
}

variable "namespace" {
  description = "The namespace for the cloudwatch alarm"
  type        = string
}

variable "period" {
  description = "The period for the cloudwatch alarm"
  type        = number
}

variable "statistic" {
  description = "The statistic for the cloudwatch alarm"
  type        = string
}

variable "threshold_scale_out" {
  description = "The threshold for the scale out alarm"
  type        = number
}

variable "comparison_operator_scale_out" {
  description = "The comparison operator for the scale out alarm"
  type        = string
}

variable "evaluation_periods_scale_out" {
  description = "The evaluation periods for the scale out alarm"
  type        = number
}

variable "scaling_adjustment_scale_out" {
  description = "The scaling adjustment for the scale out policy"
  type        = number
}

variable "asg_scale_in_name" {
  description = "The name of the scale in policy"
  type        = string
}

variable "comparison_operator_scale_in" {
  description = "The comparison operator for the scale in alarm"
  type        = string
}

variable "evaluation_periods_scale_in" {
  description = "The evaluation periods for the scale in alarm"
  type        = number
}

variable "scaling_adjustment_scale_in" {
  description = "The scaling adjustment for the scale in policy"
  type        = number
}

variable "threshold_scale_in" {
  description = "The threshold for the scale in alarm"
  type        = number
}

variable "record_type_A" {
  description = "The record type for the Route 53 record"
  type        = string
}

variable "sendgrid_api_key" {
  description = "The SendGrid API key"
  type        = string
}

variable "verification_url" {
  description = "The verification URL"
  type        = string
}

variable "lambda_file_path" {
  description = "The path to the Lambda function ZIP file"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "ipv6_cidr_block" {
  description = "The IPv6 CIDR block for the VPC"
  type        = list(string)
}
