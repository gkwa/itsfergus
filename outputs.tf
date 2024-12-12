output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "api_gateway_url" {
  value = try(local.auth_type == "iam" ? module.auth_iam[0].api_gateway_url : module.auth_key[0].api_gateway_url, "")
}

output "lambda_function_name" {
  value = try(aws_lambda_function.app.function_name, var.lambda_function_name)
}

output "aws_region" {
  value = var.aws_region
}

output "api_key" {
  value     = try(local.auth_type == "key" ? module.auth_key[0].api_key : null, null)
  sensitive = true
}

output "api_invocation_role_arn" {
  value = try(local.auth_type == "iam" ? module.auth_iam[0].api_invocation_role_arn : null, null)
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.main_queue.arn
}
