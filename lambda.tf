resource "aws_lambda_function" "app" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.app_repo.repository_url}:latest"

  depends_on = [aws_ecr_repository.app_repo]

  timeout     = 300
  memory_size = 512

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.auth_iam[0].api_gateway_execution_arn}/*/*/*"
  count         = local.auth_type == "iam" ? 1 : 0
}

resource "aws_lambda_permission" "api_gw_key" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.auth_key[0].api_gateway_execution_arn}/*/*/*"
  count         = local.auth_type == "key" ? 1 : 0
}

resource "aws_lambda_function_url" "function_url" {
  function_name      = aws_lambda_function.app.function_name
  authorization_type = "AWS_IAM"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

