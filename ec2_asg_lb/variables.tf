variable "region"{
    default = "us-east-2"
    }

variable "key_name" {
    default = "Cloudzenixkey"
  
}

variable "private_keypath" {
  default = "C:\\Users\\vinni\\Downloads\\Cloudzenixkey.pem"
}

variable "min_size"{
    default = "2"
    }

variable "max_size"{
    default = "4"
    }

variable "desired_capacity"{
    default = "3"
    }

variable "subnet1" {
  default = "subnet-95cfcaef"
}

variable "subnet2" {
  default = "subnet-d4b679bf"
}

variable "subnet3" {
  default = "subnet-faf994b6"
}

variable "health_check_grace_period" {
  default = "180"
}

variable "port" {
  default = "80"
}


variable "protocol" {
  default = "HTTP"
}