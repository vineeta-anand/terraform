provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "myinstance" {
    ami                          = "ami-0a91cd140a1fc148a"
    associate_public_ip_address  = true
    availability_zone            = "us-east-2c"
    cpu_core_count               = 1
    cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    key_name                     = "Cloudzenixkey"
    monitoring                   = false
    private_ip                   = "172.31.38.169"
    secondary_private_ips        = []
    security_groups              = [
        "launch-wizard-22",
    ]
    source_dest_check            = true
    subnet_id                    = "subnet-faf994b6"
    tags                         = {}
    tenancy                      = "default"
    volume_tags                  = {}
    vpc_security_group_ids       = [
        "sg-0e3bab70fa08498cc",
    ]

    credit_specification {
        cpu_credits = "standard"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 100
        volume_size           = 8
        volume_type           = "gp2"
    }

    timeouts {}
}