provider "aws" {
  alias = "region"
}

terraform {
  required_version = ">=0.13"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }


  backend "s3" {
    bucket         = "bucket-name"
    key            = "terraform-state/terraform.tfstate"
    dynamodb_table = "dynamodb-table-name"
    region         = "my-region"
  }
}
