# Cognito user pool imported into terraform
resource "aws_cognito_user_pool" "avior" {
    name = "avior-staging"

    schema {
          attribute_data_type      = "String"
          developer_only_attribute = false
          mutable                  = true
          name                     = "email"
          required                 = true

          string_attribute_constraints {
              max_length = "2048"
              min_length = "0"
            }
        }
    username_attributes  = ["email"]
    password_policy {
          minimum_length                   = 8
          require_lowercase                = true
          require_numbers                  = true
          require_symbols                  = false
          require_uppercase                = true
          temporary_password_validity_days = 7
        }
    lambda_config {
          create_auth_challenge          = ""
          custom_message                 = "arn:aws:lambda:us-east-1:616100519737:function:custom-cognito-message"
          define_auth_challenge          = ""
          post_authentication            = ""
          post_confirmation              = ""
          pre_authentication             = ""
          pre_sign_up                    = ""
          pre_token_generation           = ""
          user_migration                 = ""
          verify_auth_challenge_response = ""
        }

}

# Lambda function serving custom emails based on cognito triggers. 
# imported into lambda
resource "aws_lambda_function" "custom_cognito" {
    function_name = "custom-cognito-message"
    handler = "index.handler"
    memory_size = 768
    role = "arn:aws:iam::616100519737:role/service-role/custom-cognito-message-role-v29xexuq"
    runtime = "nodejs10.x"
    timeout = 3

}

# Lambda function integrating with Segment.io to enable usage analytics features 
# for the clinic dashboard. imported into terraform
resource "aws_lambda_function" "segment"{
    function_name = "usage-analytics-production"
    handler = "index.handler"
    memory_size = 512
    role = "arn:aws:iam::616100519737:role/service-role/usage-analytics-role-ky1t93md"
    runtime = "nodejs10.x"
    timeout = 3

}