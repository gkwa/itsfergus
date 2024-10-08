variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ca-central-1"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "lambda-docker-repo"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "docker-lambda-function"
}
