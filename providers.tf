terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "time" {}

data "aws_caller_identity" "current" {}
