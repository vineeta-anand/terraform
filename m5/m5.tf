module "ec2-Instance-creating"{
    source = "F:\\Terraform exercise\\module_folder"
    ami = "ami-0a91cd140a1fc148a"
    instance_type = "t2.micro"
}

output "publicId_created" {
    value = module.ec2-Instance-creating.public-ip  
}