provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "asaghatelyan"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}