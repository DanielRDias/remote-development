# The configuration for the `remote` backend.
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "centos_ami" {
  source = "./modules/ami/centos"
}

module "amazon_ami" {
  source = "./modules/ami/amazon"
}
