provider "aws"{
    region = var.region
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

resource "aws_instance" "name" {
    ami = "ami-0a91cd140a1fc148a"
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.sg01.id ]
    user_data = file("user-data.txt")
    
    connection {
     type = "ssh"
     host = self.public_ip
     user = "ubuntu"
     private_key = file(var.private_keypath)
         }
     
}



output "sg-id" {
  value = aws_security_group.sg01.id 
}

output "public-ip" {
  value = aws_instance.name.public_ip  
}
