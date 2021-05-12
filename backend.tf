#########################################
# Backend Configuration
#########################################
terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    dynamodb_table = "your-dynamodb-name"
    encrypt        = true
    key            = "s3-web/terraform.tfstate"
    region         = "ca-central-1"
  }
}

