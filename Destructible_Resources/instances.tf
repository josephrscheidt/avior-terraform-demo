# Clinic servers
resource "aws_instance" "clinic_servers" {
    count = length(var.subnets_cidr)
    ami = var.webservers_ami
    instance_type = var.instance_type
    security_groups = [data.aws_security_group.webservers.id]
    subnet_id = element(data.aws_subnet.public.*.id, count.index)
    user_data = file("clinic_user_data.sh")

    tags = {
        Name = "Clinic Server-${count.index+1}"
    }
}

# Patient Servers
resource "aws_instance" "patient_servers" {
    count = length(var.subnets_cidr)
    ami = var.webservers_ami
    instance_type = var.instance_type
    security_groups = [data.aws_security_group.webservers.id]
    subnet_id = element(data.aws_subnet.public.*.id, count.index)
    user_data = file("patient_user_data.sh")

    tags = {
        Name = "Patient Server-${count.index+1}"
    }
}

# Backend Servers
resource "aws_instance" "backend_servers" {
    count = length(var.subnets_cidr)
    ami = var.webservers_ami
    instance_type = var.instance_type
    security_groups = [data.aws_security_group.webservers.id]
    subnet_id = element(data.aws_subnet.public.*.id, count.index)
    user_data = file("backend_user_data.sh")

    tags = {
        Name = "Backend Server-${count.index+1}"
    }
}