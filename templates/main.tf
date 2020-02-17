terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

data "aws_availability_zones" "all" {}

resource "aws_instance" "web" {
  ami               = var.amis
  count             = var.instace_count
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  source_dest_check = false
  instance_type = var.instance_type
  // TODO this is a dup?
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              cd /var/www/html
              echo "Hello, HashiTalks" > index.html
              service httpd start
              EOF
  tags = {
    Name = format("hashitalk-iac-tdd-%03d", count.index + 1)
  }
}

resource "aws_security_group" "instance" {
  name = "hashitalk-iac-tdd-sg"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "example" {
  //image_id               = lookup(var.amis,var.region)
  image_id               = var.amis
  instance_type          = var.instance_type
  security_groups        = [aws_security_group.instance.id]
  key_name               = var.ssh_key_name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              cd /var/www/html
              echo "Hello, HashiTalks" > index.html
              service httpd start
              EOF
  lifecycle {
    create_before_destroy = true
  }
}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  // availability_zones = data.aws_availability_zones.all.names TF12 syntax change - fix later TODO
  //availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  availability_zones = ["eu-west-2a"]
  min_size = 1
  max_size = 1
  load_balancers = [
    aws_elb.example.name]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "hashitalk-iac-tdd-asg"
    propagate_at_launch = true
  }
}
## Security Group for ELB
resource "aws_security_group" "elb" {
  name = "hashitalk-iac-tdd-elb"
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
### Creating ELB
resource "aws_elb" "example" {
  name = "hashitalk-iac-tdd-asg"
  security_groups = [aws_security_group.elb.id]
  // availability_zones = [data.aws_availability_zones.all.names] TODO TF12 sytanx change
  //availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  availability_zones = ["eu-west-2a"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}