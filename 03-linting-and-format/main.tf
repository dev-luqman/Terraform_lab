terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "devops-web-app"
  force_destroy = true
}

resource "aws_s3_bucket_versionin" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
