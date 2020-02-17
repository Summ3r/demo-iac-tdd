terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "instance" {
  name = "-sg"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
//  egress {
//    from_port = 0
//    to_port = 0
//    protocol = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
}

resource "aws_launch_configuration" "example" {
  image_id               = var.amis
  instance_type          = var.instance_type
  security_groups        = [aws_security_group.instance.id]
  key_name               = var.ssh_key_name
  user_data = file("scripts/httpd-setup.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones = data.aws_availability_zones.all.names
  min_size = var.instace_count
  max_size = var.instace_count
  load_balancers = [aws_elb.example.name]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "randomNAme_-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name = "randomNAme_-elb"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "example" {
  name = "randomNAme_-asg"
  security_groups = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 10
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}