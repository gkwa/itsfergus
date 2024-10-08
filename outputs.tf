output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "api_gateway_url" {
  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "lambda_function_name" {
  value = aws_lambda_function.app.function_name
}

output "aws_region" {
  value = var.aws_region
}

output "api_invocation_role_arn" {
  value = aws_iam_role.api_invocation_role.arn
}
