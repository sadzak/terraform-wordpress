# Create ELB Security Group
resource "aws_security_group" "elb-sg" {
  name        = "elb-sg"
  description = "Access to ELB"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "elb-sg"
    Stage = "${var.stage}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Web Server Security Group
resource "aws_security_group" "webserver-sg" {
  name        = "webserver-sg"
  description = "Access to web servers"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "webserver-sg"
    Stage = "${var.stage}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create RDS Security Group
resource "aws_security_group" "rds-mysql-sg" {
  name        = "rds-mysql-sg"
  description = "Access to RDS MySQL"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "rds-mysql-sg"
    Stage = "${var.stage}"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet}"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet}"]
  }
}

# Create EFS Security Group
resource "aws_security_group" "efs-sg" {
  name        = "efs-sg"
  description = "Access to EFS"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "efs-sg"
    Stage = "${var.stage}"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.public_subnet}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.public_subnet}"]
  }
}
