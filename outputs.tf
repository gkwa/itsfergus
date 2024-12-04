output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "api_gateway_url" {
  value = local.auth_type == "iam" ? module.auth_iam[0].api_gateway_url : module.auth_key[0].api_gateway_url
}

output "lambda_function_name" {
  value = aws_lambda_function.app.function_name
}

output "aws_region" {
  value = var.aws_region
}

output "api_key" {
  value     = local.auth_type == "key" ? module.auth_key[0].api_key : null
  sensitive = true
}

output "api_invocation_role_arn" {
  value = local.auth_type == "iam" ? module.auth_iam[0].api_invocation_role_arn : null
}
