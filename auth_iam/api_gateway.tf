resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "lambda-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_iam_role" "api_gateway_execution_role" {
  name = "api_gateway_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_lambda_policy" {
  name = "api_gateway_lambda_policy"
  role = aws_iam_role.api_gateway_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = var.aws_lambda_function_arn
      }
    ]
  })
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.aws_lambda_function_arn
  integration_method = "POST"
  credentials_arn    = aws_iam_role.api_gateway_execution_role.arn
}

# Root path route
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  route_key          = "ANY /"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "AWS_IAM"
}

# Catch-all route for proxy integrations
resource "aws_apigatewayv2_route" "lambda_route_catchall" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  route_key          = "ANY /{proxy+}" # This is the correct syntax for HTTP APIs
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "AWS_IAM"
}
