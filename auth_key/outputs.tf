output "api_gateway_url" {
  value = "${aws_api_gateway_stage.lambda_stage.invoke_url}/{proxy}"
}

output "api_key" {
  value     = aws_api_gateway_api_key.lambda_key.value
  sensitive = true
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.lambda_api.execution_arn
}
