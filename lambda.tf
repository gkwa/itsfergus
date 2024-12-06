resource "aws_lambda_function" "app" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.app_repo.repository_url}:latest"

  depends_on = [
    aws_ecr_repository.app_repo,
    aws_iam_role_policy_attachment.lambda_logs,
    aws_iam_role.lambda_role,
    aws_iam_role_policy.lambda_kms,
    aws_iam_role_policy.lambda_ecr_kms
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

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com", "sts.amazonaws.com"]
        }
      }
    ]
  })

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy" "lambda_logging" {
  name = "lambda_logging_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy" "lambda_ecr" {
  name = "lambda_ecr_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_kms" {
  name = "lambda_kms_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:RetireGrant",
          "kms:CreateGrant",
          "kms:ListGrants"
        ]
        Resource = [
          "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*",
          "arn:aws:kms:ca-central-1:193048895737:key/24a775bf-745d-468a-9e2e-f3566aaae9d2",
          "arn:aws:kms:ca-central-1:193048895737:key/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:ListKeys",
          "kms:ListAliases"
        ]
        Resource = "*"
      }
    ]
  })
}

# Add explicit ECR KMS permissions
resource "aws_iam_role_policy" "lambda_ecr_kms" {
  name = "lambda_ecr_kms_policy"
  role = aws_iam_role.lambda_role.id

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
        Resource = "${aws_ecr_repository.app_repo.arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })
}
