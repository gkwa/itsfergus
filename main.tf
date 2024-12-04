locals {
  auth_type = var.auth_type
}

module "auth_iam" {
  source = "./auth_iam"
  count  = local.auth_type == "iam" ? 1 : 0

  aws_lambda_function_arn  = aws_lambda_function.app.arn
  aws_lambda_function_name = var.lambda_function_name
  aws_region               = var.aws_region
}

module "auth_key" {
  source = "./auth_key"
  count  = local.auth_type == "key" ? 1 : 0

  aws_lambda_function_arn  = aws_lambda_function.app.arn
  aws_lambda_function_name = var.lambda_function_name
  aws_region               = var.aws_region
}

