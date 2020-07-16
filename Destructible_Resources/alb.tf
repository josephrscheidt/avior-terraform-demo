# Create clinic load balancer
resource "aws_alb" "clinic_alb" {
    name = "clinic-alb"
    subnets = [data.aws_subnet.public.0.id, data.aws_subnet.public.1.id]
    security_groups = [data.aws_security_group.alb.id]
    internal           = false
    load_balancer_type = "application"
    idle_timeout       = 60
    ip_address_type    = "ipv4"
    enable_deletion_protection = false

    tags = {
        Name = "Clinic ALB"
    }
}

# Add an https listener on port 443
resource "aws_alb_listener" "clinic_https" {

    load_balancer_arn = aws_alb.clinic_alb.arn
    protocol          = "HTTPS"
    port              = 443
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = data.aws_acm_certificate.tls.arn

    default_action {

        target_group_arn = aws_alb_target_group.clinic_servers.arn
	type = "forward"
    }
}

# Add an http listener on port 80
resource "aws_alb_listener" "clinic_http" {

    load_balancer_arn = aws_alb.clinic_alb.arn
    protocol          = "HTTP"
    port              = 80

    default_action {

        type = "redirect"
        redirect {

            port        = 443
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Add a target group pointing at the clinic servers
resource "aws_alb_target_group" "clinic_servers" {

    vpc_id      = data.aws_vpc.terraform_vpc.id
    name        = "clinic-servers"
    protocol    = "HTTP"
    port        = 80
    target_type = "instance"

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        protocol            = "HTTP"
        timeout             = 10
        path                = "/"
        interval            = 30
        matcher             = "200"
    }

    tags = {
        Name = "Clinic Server Group"
    }

}

# Attach to clinic server group
resource "aws_lb_target_group_attachment" "clinic_servers" {
  count            = length(var.azs)
  target_group_arn = aws_alb_target_group.clinic_servers.arn
  target_id        =  element(split(",", join(",", aws_instance.clinic_servers.*.id)), count.index)
  port             = 80
}

# Create patient load balancer
resource "aws_alb" "patient_alb" {
    name = "patient-alb"
    subnets = [data.aws_subnet.public.0.id, data.aws_subnet.public.1.id]
    security_groups = [data.aws_security_group.alb.id]
    internal           = false
    load_balancer_type = "application"
    idle_timeout       = 60
    ip_address_type    = "ipv4"
    enable_deletion_protection = false

    tags = {
        Name = "Patient ALB"
    }
}

# Add an https listener on port 443
resource "aws_alb_listener" "patient_https" {

    load_balancer_arn = aws_alb.patient_alb.arn
    protocol          = "HTTPS"
    port              = 443
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = data.aws_acm_certificate.tls.arn

    default_action {

        target_group_arn = aws_alb_target_group.patient_servers.arn
	type = "forward"
    }
}

# Add an http listener on port 80
resource "aws_alb_listener" "patient_http" {

    load_balancer_arn = aws_alb.patient_alb.arn
    protocol          = "HTTP"
    port              = 80

    default_action {

        type = "redirect"
        redirect {

            port        = 443
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Add a target group pointing at the patient servers
resource "aws_alb_target_group" "patient_servers" {

    vpc_id      = data.aws_vpc.terraform_vpc.id
    name        = "patient-servers"
    protocol    = "HTTP"
    port        = 80
    target_type = "instance"

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        protocol            = "HTTP"
        timeout             = 10
        path                = "/"
        interval            = 30
        matcher             = "200"
    }

    tags = {
        Name = "Patient Server Group"
    }

}

# Attach to target group
resource "aws_lb_target_group_attachment" "patient_servers" {
  count            = length(var.azs)
  target_group_arn = aws_alb_target_group.patient_servers.arn
  target_id        =  element(split(",", join(",", aws_instance.patient_servers.*.id)), count.index)
  port             = 80
}

# Create backend load balancer
resource "aws_alb" "backend_alb" {
    name = "backend-alb"
    subnets = [data.aws_subnet.public.0.id, data.aws_subnet.public.1.id]
    security_groups = [data.aws_security_group.alb.id]
    internal           = false
    load_balancer_type = "application"
    idle_timeout       = 60
    ip_address_type    = "ipv4"
    enable_deletion_protection = false

    tags = {
        Name = "Backend ALB"
    }
}

# Add an https listener on port 443
resource "aws_alb_listener" "backend_https" {

    load_balancer_arn = aws_alb.backend_alb.arn
    protocol          = "HTTPS"
    port              = 443
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = data.aws_acm_certificate.tls.arn

    default_action {

        target_group_arn = aws_alb_target_group.backend_servers.arn
	type = "forward"
    }
}

# Add an http listener on port 80
resource "aws_alb_listener" "backend_http" {

    load_balancer_arn = aws_alb.backend_alb.arn
    protocol          = "HTTP"
    port              = 80

    default_action {

        type = "redirect"
        redirect {

            port        = 443
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Add a target group pointing at the patient servers
resource "aws_alb_target_group" "backend_servers" {

    vpc_id      = data.aws_vpc.terraform_vpc.id
    name        = "backend-servers"
    protocol    = "HTTP"
    port        = 80
    target_type = "instance"

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        protocol            = "HTTP"
        timeout             = 10
        path                = "/"
        interval            = 30
        matcher             = "200"
    }

    tags = {
        Name = "Backend Server Group"
    }

}

# Attach to target group
resource "aws_lb_target_group_attachment" "backend_servers" {
  count            = length(var.azs)
  target_group_arn = aws_alb_target_group.backend_servers.arn
  target_id        =  element(split(",", join(",", aws_instance.backend_servers.*.id)), count.index)
  port             = 80
}

# output "clinic-dns-name" {
#     value = aws_alb.clinic_alb.dns_name
# }
# output "patient-dns-name" {
#     value = aws_alb.patient_alb.dns_name
# }

# output "backend-dns-name" {
#     value = aws_alb.backend_alb.dns_name
# }