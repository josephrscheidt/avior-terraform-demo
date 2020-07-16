Below are the import commands that were used to load the existing AWS resources into this terraform environment. DO NOT RUN TERRAFORM DESTROY

terraform import aws_route53_zone.zone Z1M46UMT2PY8S

terraform import aws_s3_bucket.terraform terraform.avioranalytics.net

terraform import aws_s3_bucket.avior avior

terraform import aws_cognito_user_pool.avior us-east-1_aGBWAn8G9

terraform import aws_lambda_function.custom_cognito custom-cognito-message

terraform import aws_lambda_function.segment usage-analytics-production

terraform import aws_rds_cluster.database sandbox-database-cluster

terraform import aws_cloudfront_distribution.terraform E31D82EZ4C4EVL

terraform import aws_vpc.terraform_vpc vpc-0c12de6ae6d738134

terraform import 'aws_subnet.public[0]' subnet-02a0a302bb4fc7cff

terraform import 'aws_subnet.public[1]' subnet-0e91376ea4771a175

terraform import aws_internet_gateway.terraform_igw igw-0385e932790051faa

terraform import aws_route_table.public_rt rtb-0ddd0205d6b43162e

terraform import aws_security_group.webservers sg-04dc483bf0722c8c2

terraform import aws_security_group.alb sg-0867787121ae6dccc

terraform import aws_route53_record.clinic Z35SXDOTRQ7X7K_terraclinic.avioranalytics.net_A

terraform import aws_route53_record.backend Z35SXDOTRQ7X7K_terraapi.avioranalytics.net_A

terraform import aws_route53_record.patient Z35SXDOTRQ7X7K_terrapatient.avioranalytics.net_A

terraform import aws_route53_record.terraform Z2FDTNDATAQYW2_terraform.avioranalytics.net_A

