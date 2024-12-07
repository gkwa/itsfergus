variable "aws_lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function"
}

variable "aws_lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy to"
}
