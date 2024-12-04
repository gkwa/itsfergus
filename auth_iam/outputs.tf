output "api_gateway_url" {
  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "api_invocation_role_arn" {
  value = aws_iam_role.api_invocation_role.arn
}

output "api_gateway_execution_arn" {
  value = aws_apigatewayv2_api.lambda_api.execution_arn
}
