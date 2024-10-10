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

