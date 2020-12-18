provider "aws"{
    region = var.region
}

terraform {
  backend "s3" {
    bucket = "storetfstatefiles"
    key    = "asg_alb_ec2/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_default_vpc" "vpc-lb" {
  
}

resource "aws_security_group" "sg01" {
  name        = "allow_ssh_http"
  description = "Allow inbound traffic"

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http"
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
    Name = "allow_ssh_http"
  }
}

resource "aws_launch_configuration" "asg-launch-config" {
  name = "asg-launch-config"
  image_id = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  key_name = var.key_name
  user_data = file("user-data.txt")
  security_groups = [ aws_security_group.sg01.id ]
  
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file(var.private_keypath)
  }
}


resource "aws_autoscaling_group" "asg-01" {
  name = "asg-01"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  launch_configuration = aws_launch_configuration.asg-launch-config.name
  vpc_zone_identifier = [ var.subnet1,var.subnet2,var.subnet3 ]
  health_check_grace_period = var.health_check_grace_period
  target_group_arns = [ aws_lb_target_group.tg-01.arn ]
}

resource "aws_security_group" "sg-alb" {
  name        = "allow_http"
  description = "Allow inbound traffic"

  ingress {
    description = "allow http"
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
    Name = "allow_http"
  }
}


resource "aws_lb_target_group" "tg-01" {
  name = "tg-01"
  port = var.port
  protocol = var.protocol
  vpc_id   = aws_default_vpc.vpc-lb.id
  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
  }
}

resource "aws_lb" "alb-01" {
  name = "alb-01"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.sg-alb.id ]
  subnets = [ var.subnet1,var.subnet2,var.subnet3 ]
  ip_address_type = "ipv4"
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb-01.arn
  port = var.port
  protocol = var.protocol
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg-01.arn
  }
  }


output "asg-id" {
  value = aws_autoscaling_group.asg-01.id 
}


output "alb-id" {
  value = aws_lb.alb-01.id
}