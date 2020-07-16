# VPC
resource "aws_vpc" "terraform_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "TerraformVPC"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "terraform_igw" {
    vpc_id = aws_vpc.terraform_vpc.id
    tags = {
        Name = "main"
    }
}

# Subnets: public
resource "aws_subnet" "public" {
    count = length(var.subnets_cidr)
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = element(var.subnets_cidr, count.index)
    availability_zone = element(var.azs, count.index)
    map_public_ip_on_launch = "true"
    tags = {
        Name = "Terraform Subnet-${count.index+1}"
    }
}

# Route Table: attach Internet Gateway
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraform_igw.id
    }
    tags = {
        Name = "publicRouteTable"
    }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
    count = length(var.subnets_cidr)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public_rt.id
}

# Security Group, port 80 ingress
resource "aws_security_group" "webservers" {
    name = "allow_http"
    description = "Allow inbound HTTP traffic"
    vpc_id  =  aws_vpc.terraform_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Allow HTTP"
    }
}

# Security Group, port 443 and 80 ingress
resource "aws_security_group" "alb" {
    name = "allow_http_https"
    description = "Allow inbound HTTP and HTTPS traffic"
    vpc_id = aws_vpc.terraform_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ALB Security Group"
    }
}