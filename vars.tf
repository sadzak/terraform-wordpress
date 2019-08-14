# AWS Credentials
variable "aws_access_key" {
  default = "INSERT_AWS_ACCESS_KEY"
}
variable "aws_secret_key" {
  default = "INSERT_AWS_SECURITY_KEY"
}
variable "aws_region" {
  default = "eu-west-1"
}

# Tag infrastructure as dev/stage/live
variable "stage" {
  default = "dev"
}

# SSH key name (you must create and download key or import existing one)
variable "aws_key_name" {
  default = "INSERT_YOUR_KEY_NAME"
}

# RDS data/credentials definitions
variable "rds_data" {
  description = "RDS Access data"
  type        = "map"

  default = {
    identifier     = "wordpress"
    instance_class = "db.t2.micro"
    username       = "wordpress"
    password       = "INSERT_WORDPRESS_PASSWORD"
    db_name        = "wordpress"
  }
}

# AWS AMI (Ubuntu linux 18.04 in eu-west-1 zone)
# Choose your AMI according to your needs and AWS region
variable "linux_ami" {
  default = "ami-06358f49b5839867c"
}

# Web Server instance type 
variable "instance_type" {
  default = "t2.micro"
}

# VPC CIDR definition
variable "vpc_cidr" {
  description = "VPC"
  default     = "10.0.0.0/16"
}

# Public subnet definition
variable "public_subnet" {
  description = "Public subnet"
  default     = "10.0.0.0/24"
}

# RDS subnets definition
variable "db_private_subnet_a" {
  description = "Private subnet AZ-a"
  default     = "10.0.2.0/24"
}
variable "db_private_subnet_b" {
  description = "Private subnet AZ-b"
  default     = "10.0.4.0/24"
}
