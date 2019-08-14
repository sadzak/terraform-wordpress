resource "aws_launch_configuration" "wordpress_lc" {
  depends_on      = [aws_efs_mount_target.wordpress-mount]
  name_prefix     = "wordpress-lc"
  image_id        = "${var.linux_ami}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.webserver-sg.id}"]
  user_data       = "${data.template_file.wp_config.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  name                      = "wordpress-asg"
  launch_configuration      = "${aws_launch_configuration.wordpress_lc.name}"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["${aws_subnet.public_subnet.id}"]
  load_balancers            = ["${aws_elb.elb.name}"]
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "${var.stage}-wordpress-webserver"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
