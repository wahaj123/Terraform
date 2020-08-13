# Create a new load balancer
resource "aws_elb" "alb" {
  name            = "Application-loadbalancer-${terraform.workspace}"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet

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
    target              = "HTTP:80/SamplePage.php"
    interval            = 30
  }

  instances                   = var.ec2_instance
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "alb-${terraform.workspace}"
  }
}
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${terraform.workspace}"
  description = "Allow internet traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "incoming for ec2-instance"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-sg"
  }

}
