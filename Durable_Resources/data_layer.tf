resource "aws_rds_cluster" "database"{
    availability_zones = ["us-east-1a","us-east-1c","us-east-1e"]
    cluster_members = ["sandbox-database"]
    database_name = "avior"
    engine = "aurora"
    port = 3306
    vpc_security_group_ids = ["sg-aa0cffeb"]
    backup_retention_period = 7
    master_username = "root"
    skip_final_snapshot = true
    
}

resource "aws_s3_bucket" "avior" {
    bucket = "avior"
    acl = "public-read"
}

resource "aws_s3_bucket_policy" "avior"{
    bucket = "avior"
    policy = jsonencode(
            {
              Statement = [
                  {
                      Action    = "s3:GetObject"
                      Effect    = "Allow"
                      Principal = {
                          AWS = "*"
                        }
                      Resource  = "arn:aws:s3:::avior/*"
                      Sid       = "AllowPublicRead"
                    },
                ]
              Version   = "2008-10-17"
            }
        )
}

# S3 bucket for hosting static website
resource "aws_s3_bucket" "terraform" {
    acl = "public-read"
    bucket = "terraform.avioranalytics.net"

    website {
        error_document = "index.html"
        index_document = "index.html"
        }

    tags = {
        Name = "terraform.avioranalytics.net"
    }
}

resource "aws_s3_bucket_policy" "terraform" {
  bucket = aws_s3_bucket.terraform.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicGet",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::terraform.avioranalytics.net/*"
        }
    ]
}
POLICY
}
