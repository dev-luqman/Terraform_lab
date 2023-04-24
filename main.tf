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

# resource "aws_instance" "example" {
#   ami           = "ami-007855ac798b5175e" # Ubuntu 20.04 LTS // us-east-1 // Pleaase Change accordingly
#   instance_type = "tX.mEcro"
# }


resource "aws_instance" "ec2_test" {
  ami           = "ari-67b95e0e"
  instance_type = "t2.micro"
}
