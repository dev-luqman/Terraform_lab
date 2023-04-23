terraform {
  #############################################################
  ## **** LOCAL BACKEND ****
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  ## PLEASE CHECK DIR :=> 01-backend beform uncommenting the below code
  #############################################################
  # backend "s3" {
  #   bucket         = "devops-terraform-state" # REPLACE WITH YOUR BUCKET NAME
  #   key            = "tf-bootstrap/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-locking"
  #   encrypt        = true
  # }

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

resource "aws_instance" "example" {
  ami           = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1 // Pleaase Change accordingly
  instance_type = "t2.micro"
}
