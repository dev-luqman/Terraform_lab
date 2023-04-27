terraform {
  required_version = ">= 0.15, < 2.0.0"
  backend "remote" {
    organization = "devOps-sample" // insert your terraform cloud organization

    workspaces {
      name = "backend-test" // insert your terraform cloud organization
    }
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
