# Create ELB
# Create (classic) Elastic Load Balancer
resource "aws_elb" "elb" {
  name            = "${var.stage}-elb"
  security_groups = ["${aws_security_group.elb-sg.id}"]
  subnets         = ["${aws_subnet.public_subnet.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/readme.html" # We know that wordpress is deployed
    interval            = 5
  }

  tags = {
    Name  = "${var.stage}-elb"
    Stage = "${var.stage}"
  }
}

output "elb" {
  value = "${aws_elb.elb.dns_name}"
}
