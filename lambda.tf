resource "aws_iam_role" "lambda_api_role" {
  name = "lambda_api_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com", "apigateway.amazonaws.com"]
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_ecr_policy" {
  name = "lambda_ecr_policy"
  role = aws_iam_role.lambda_api_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_kms_policy" {
  name = "lambda_kms_policy"
  role = aws_iam_role.lambda_api_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:CreateGrant",
          "kms:RetireGrant",
          "kms:ListGrants",
          "kms:ReEncrypt*"
        ]
        Resource = [
          "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*",
          "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:alias/aws/ecr",
          "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:alias/aws/lambda"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logs_policy" {
  name = "lambda_logs_policy"
  role = aws_iam_role.lambda_api_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_api_policy" {
  name = "lambda_api_policy"
  role = aws_iam_role.lambda_api_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
          "execute-api:Invoke",
          "execute-api:ManageConnections"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "time_sleep" "wait_for_role" {
  depends_on = [
    aws_iam_role.lambda_api_role,
    aws_iam_role_policy.lambda_ecr_policy,
    aws_iam_role_policy.lambda_kms_policy,
    aws_iam_role_policy.lambda_logs_policy,
    aws_iam_role_policy.lambda_api_policy,
    aws_iam_role_policy_attachment.lambda_basic
  ]

  create_duration = "10s"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "app" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_api_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.app_repo.repository_url}:latest"

  depends_on = [
    aws_ecr_repository.app_repo,
    time_sleep.wait_for_role,
    aws_cloudwatch_log_group.lambda_log_group
  ]

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
