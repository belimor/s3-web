variable "project" {
  type        = string
  description = "Project name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "env" {
  type        = string
  description = "Depolyment environment"
}

variable "custom_tags" {
  description = ""
  type        = map(string)
}

variable "s3_web_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "error_document" { type = string }
variable "index_document" { type = string }
variable "redirect_path" { type = string }
variable "redirect_target" { type = string }
variable "comment" { type = string }
variable "geo_restriction_type" { type = string }
variable "geo_restriction_location" { type = list(any) }
variable "root_object" { type = string }
variable "price_class" { type = string }
variable "cert_region" { type = string }
variable "cert_domain" { type = string }

