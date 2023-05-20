terraform {
  required_version = ">= 0.15, < 2.0.0"
  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  backend "s3" {
    bucket         = "515967506259-devops-terraform-state" # REPLACE WITH YOUR BUCKET NAME
    key            = "tf-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

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

variable "db_pass" {
  description = "password for database"
  type        = string
  sensitive   = true
}

locals {
  environment_name = terraform.workspace
}

module "web_app" {
  source = "./webApp"

  # Input Variables
  bucket_prefix    = "web-app-data-${local.environment_name}"
  domain           = "devopsdeployed.com"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  create_dns_zone  = terraform.workspace == "production" ? true : false
  db_name          = "${local.environment_name}mydb"
  db_user          = "foo"
  db_pass          = var.db_pass
}
