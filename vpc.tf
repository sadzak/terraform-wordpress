# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name  = "${var.stage} VPC"
    Stage = "${var.stage}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "${var.stage}_vpc_igw"
    Stage = "${var.stage}"
  }
}

# Create subnets
resource "aws_subnet" "public_subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public_subnet}"
  availability_zone = "eu-west-1a"

  tags = {
    Name  = "${var.stage} Public Subnet"
    Stage = "${var.stage}"
  }
}

resource "aws_subnet" "db_private_subnet_a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.db_private_subnet_a}"
  availability_zone = "eu-west-1a"

  tags = {
    Name  = "${var.stage} Private Subnet A"
    Stage = "${var.stage}"
  }
}
resource "aws_subnet" "db_private_subnet_b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.db_private_subnet_b}"
  availability_zone = "eu-west-1b"

  tags = {
    Name  = "${var.stage} Private Subnet B"
    Stage = "${var.stage}"
  }
}

# Create routing table 
resource "aws_route_table" "routing_table_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc_igw.id}"
  }

  tags = {
    Name  = "Main Routing table - ${var.stage}_vpc"
    Stage = "${var.stage}"
  }
}

# Associate routing table
resource "aws_route_table_association" "public_route_table" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.routing_table_public.id}"
}
