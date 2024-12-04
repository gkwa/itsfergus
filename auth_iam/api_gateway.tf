resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "lambda-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.app.invoke_arn
  integration_method = "POST"
  credentials_arn    = aws_iam_role.api_gateway_execution_role.arn
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  route_key          = "ANY /"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "AWS_IAM"
}
