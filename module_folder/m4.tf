provider "aws"{
    region = var.region
}

variable "ami"{}
variable "instance_type"{}

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

resource "aws_instance" "ec2-Instance-creation" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.sg01.id ]
    user_data = file("/home/ubuntu/terraform/module_folder/user-data.txt")
    
    connection {
     type = "ssh"
     host = self.public_ip
     user = "ubuntu"
     private_key = file(var.private_keypath)
         }

  }


output "public-ip" {
  value = aws_instance.ec2-Instance-creation.public_ip  
}
