terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "nat_gateway_modification" {
  source = "./homerModule/main.tf"

  # Input Variables
  vpc_id = "enter your valid vpc id"
}
