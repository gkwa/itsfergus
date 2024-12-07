locals {
  auth_type = var.auth_type
}

module "auth_iam" {
  count  = local.auth_type == "iam" ? 1 : 0
  source = "./auth_iam"

  aws_lambda_function_arn  = try(aws_lambda_function.app.arn, "")
  aws_lambda_function_name = var.lambda_function_name
  aws_region               = var.aws_region
}

module "auth_key" {
  count  = local.auth_type == "key" ? 1 : 0
  source = "./auth_key"

  aws_lambda_function_arn  = try(aws_lambda_function.app.arn, "")
  aws_lambda_function_name = var.lambda_function_name
  aws_region               = var.aws_region
}
