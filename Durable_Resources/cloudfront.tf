# CloudFront distribution with S3 bucket
resource "aws_cloudfront_distribution" "terraform" {
  aliases             = ["terraform.avioranalytics.net"]
  default_root_object = "index.html"
  enabled             = true
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.terraform.website_endpoint
    origin_id   = "S3-${var.domain}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.tls.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.domain}" # Replace

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  tags = {
    Name = "Terraform CouldFront"
  }
}