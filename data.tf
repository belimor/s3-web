provider "aws" {
  alias   = "virginia"
  region  = var.cert_region
}

data "aws_acm_certificate" "amazon_issued" {
  domain      = var.cert_domain
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
  provider    = aws.virginia
}

