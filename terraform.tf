#########################################
# S3 Website
#########################################

resource "aws_s3_bucket" "s3-web-flyhtturn" {
  bucket = var.s3_web_bucket_name

  acl = "public-read"

  versioning {
    enabled = false
  }

  website {
    error_document = var.error_document
    index_document = var.index_document
  }

  tags = merge(
    var.custom_tags,
    {
      Name = var.s3_web_bucket_name,
      Env  = var.env
    }
  )
}

resource "aws_s3_bucket_policy" "s3-web-bucket-policy" {
  bucket = aws_s3_bucket.s3-web-flyhtturn.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.s3-web-flyhtturn.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_object" "home_object" {
  key    = var.redirect_path
  bucket = aws_s3_bucket.s3-web-flyhtturn.id

  website_redirect = "/${var.redirect_target}"
}

#########################################
# CloudFront distribution
#########################################

locals {
  s3_origin_id = "S3-${var.s3_web_bucket_name}"
}

resource "aws_cloudfront_distribution" "s3-web-distribution" {

  origin {
    domain_name = aws_s3_bucket.s3-web-flyhtturn.website_endpoint
    origin_id   = local.s3_origin_id

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2", ]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comment
  default_root_object = var.root_object

  price_class = var.price_class

  aliases = [var.cert_domain]

  #  logging_config {
  #    include_cookies = false
  #    bucket          = "mylogs.s3.amazonaws.com"
  #    prefix          = "myprefix"
  #  }

  default_cache_behavior {
    cache_policy_id = aws_cloudfront_cache_policy.cache_behavior_policy.id

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.amazon_issued.arn
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_location
    }
  }

  tags = merge(
    var.custom_tags,
    {
      Env = var.env
    }
  )

}

resource "aws_cloudfront_cache_policy" "cache_behavior_policy" {
  name        = "FLYHT-CachingOptimized"
  comment     = "Default policy when CF compression is enabled"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

