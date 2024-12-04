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
  authorization_type = "NONE"
  api_key_required   = true
}

resource "aws_api_gateway_api_key" "lambda_key" {
  name = "lambda-api-key"
}

resource "aws_api_gateway_usage_plan" "lambda_usage_plan" {
  name = "lambda-usage-plan"

  api_stages {
    api_id = aws_apigatewayv2_api.lambda_api.id
    stage  = aws_apigatewayv2_stage.lambda_stage.name
  }
}

resource "aws_api_gateway_usage_plan_key" "lambda_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.lambda_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.lambda_usage_plan.id
}

