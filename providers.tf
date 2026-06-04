terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.48.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.14.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "time" {}

data "aws_caller_identity" "current" {}
