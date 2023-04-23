terraform {
  backend "remote" {
    organization = "devOps-sample"

    workspaces {
      name = "backend-test"
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
