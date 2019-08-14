# Create RDS Subnet group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet"
  subnet_ids = ["${aws_subnet.db_private_subnet_a.id}", "${aws_subnet.db_private_subnet_b.id}"]

  tags = {
    Name  = "${var.stage} DB subnet group"
    Stage = "${var.stage}"
  }
}

# Create RDS instance
resource "aws_db_instance" "rds_mysql_db" {
  identifier             = "${var.rds_data["identifier"]}"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "${var.rds_data["instance_class"]}"
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.rds-mysql-sg.id}"]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true

  name     = "${var.rds_data["db_name"]}"
  username = "${var.rds_data["username"]}"
  password = "${var.rds_data["password"]}"

  tags = {
    Name  = "${var.stage} RDS wordpress DB"
    Stage = "${var.stage}"
  }
}

# Generate WordPress config file with data from RDS instance and vars
data "template_file" "wp_config" {
  depends_on = [aws_db_instance.rds_mysql_db]
  template   = "${file("${path.module}/configure_server.tpl")}"
  vars = {
    db_name  = "${var.rds_data["db_name"]}"
    username = "${var.rds_data["username"]}"
    password = "${var.rds_data["password"]}"
    hostname = "${aws_db_instance.rds_mysql_db.address}"
    wordpress_efs_dns_name = "${aws_efs_file_system.wordpressEFS.dns_name}"
  }
}

# Print out RDS endpoint
output "rds_endpoint" {
  value = "${aws_db_instance.rds_mysql_db.address}"
}
