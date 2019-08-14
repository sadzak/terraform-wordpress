resource "aws_efs_file_system" "wordpressEFS" {
  creation_token = "EFS for WordPress"
}

resource "aws_efs_mount_target" "wordpress-mount" {
  file_system_id  = "${aws_efs_file_system.wordpressEFS.id}"
  subnet_id       = "${aws_subnet.public_subnet.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}

output "efs" {
  value = "${aws_efs_file_system.wordpressEFS.dns_name}"
}
