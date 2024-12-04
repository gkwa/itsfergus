output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "api_gateway_url" {
  value = aws_api_gateway_stage.api.invoke_url
}

output "lambda_function_name" {
  value = aws_lambda_function.app.function_name
}

output "aws_region" {
  value = var.aws_region
}

output "api_key_value" {
  value     = aws_api_gateway_api_key.api_key.value
  sensitive = true
}
