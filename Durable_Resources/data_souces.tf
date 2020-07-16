# Get the ACM cert from AWS
data "aws_acm_certificate" "tls" {
    domain   = "*.avioranalytics.net"
    statuses = [ "ISSUED" ]
}

# Get albs for the DNS records
data "aws_alb" "clinic_alb" {
    name = "clinic-alb"
    # filter {
    #     name = "tag:Name"
    #     values = ["Clinic ALB"]
    # }
}

data "aws_alb" "patient_alb" {
    name = "patient-alb"
    # filter {
    #     name = "tag:Name"
    #     values = ["Patient ALB"]
    # }
}

data "aws_alb" "backend_alb" {
    name = "backend-alb"
    # filter {
    #     name = "tag:Name"
    #     values = ["Backend ALB"]
    # }
}