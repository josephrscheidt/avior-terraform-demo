# Need to get all dependencies here. AWS Cert, vpc, subnets, route table etc.

# Get the ACM cert from AWS
data "aws_acm_certificate" "tls" {
    domain   = "*.avioranalytics.net"
    statuses = [ "ISSUED" ]
}

# VPC
data "aws_vpc" "terraform_vpc" {
    filter {
        name = "tag:Name"
        values = ["TerraformVPC"]
    }
}

# Subnets
data "aws_subnet" "public" {
    count = length(var.subnets_cidr)

    filter {
        name = "tag:Name"
        values = ["Terraform Subnet-${count.index+1}"]
    }
}

# Security Groups
data "aws_security_group" "webservers" {
    filter {
        name = "tag:Name"
        values = ["Allow HTTP"]
    }
}

data "aws_security_group" "alb" {
    filter {
        name = "tag:Name"
        values = ["ALB Security Group"]
    }
}


