terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "time" {}

data "aws_caller_identity" "current" {}
