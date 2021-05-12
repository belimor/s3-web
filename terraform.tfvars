############################################################################
# Terraform module to provision 
# S3 Website bucket and CloudFront Distribution 
############################################################################
env         = "dev"
aws_region  = "ca-central-1"

project = "MyProject"

custom_tags = {
  Owner    = "Dmitry"
  Project  = "MyProject"
}

# S3 bucket variables
s3_web_bucket_name = "my.domain.com"
error_document     = "index.html"
index_document     = "index.html"
redirect_path      = "home"
redirect_target    = "index.html"

# CloudFront variables
comment                  = "FLYHTTurn CloudFront Distribution"
price_class              = "PriceClass_100"
cert_region              = "us-east-1"
cert_domain              = "my.domain.com"
root_object              = "index.html"
geo_restriction_type     = "whitelist"
geo_restriction_location = ["CA", "US"]
