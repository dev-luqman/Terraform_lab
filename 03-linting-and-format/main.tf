terraform {

  required_version = "0.13.5"
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

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "error"
  }
}

resource "aws_instance" "instance_2" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "g2X"
}

resource "aws_instance" "ec2_test" {
  ami           = "ari-67b95e0e"
  instance_type = "t1.medium"
}
