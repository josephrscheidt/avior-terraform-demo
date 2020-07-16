# Hosted zone in Route53
resource "aws_route53_zone" "zone" {
  name = "avioranalytics.net"

  tags = {
    Name = "avioranalytics.net"
  }
}

#  Domain DNS record for clinic
resource "aws_route53_record" "clinic" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "terraclinic.avioranalytics.net"
  type    = "A"

  alias {
    name                   = data.aws_alb.clinic_alb.dns_name
    zone_id                = data.aws_alb.clinic_alb.zone_id
    evaluate_target_health = false
  }
}

# Domain DNS record for patient
resource "aws_route53_record" "patient" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "terrapatient.avioranalytics.net"
  type    = "A"

  alias {
    name                   = data.aws_alb.patient_alb.dns_name
    zone_id                = data.aws_alb.patient_alb.zone_id
    evaluate_target_health = false
  }
}

# Alias record for backend
resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "terraapi.avioranalytics.net"
  type    = "A"

  alias {
    name                   = data.aws_alb.backend_alb.dns_name
    zone_id                = data.aws_alb.backend_alb.zone_id
    evaluate_target_health = false
  }
}

# Alias record for cloudfront distribution
resource "aws_route53_record" "terraform" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "terraform.avioranalytics.net"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.terraform.domain_name
    zone_id                = aws_cloudfront_distribution.terraform.hosted_zone_id
    evaluate_target_health = false
  }
}