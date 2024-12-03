terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}