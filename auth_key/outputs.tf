output "api_gateway_url" {
  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "api_key" {
  value     = aws_api_gateway_api_key.lambda_key.value
  sensitive = true
}

output "api_gateway_execution_arn" {
  value = aws_apigatewayv2_api.lambda_api.execution_arn
}
