# The configuration for the `remote` backend.
terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "dias"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "remote-development"
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

module "centos_ami" {
  source = "./aws/terraform/data/centos"
}
