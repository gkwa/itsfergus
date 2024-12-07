resource "aws_iam_role" "api_invocation_role" {
  name = "api_invocation_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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

resource "aws_iam_role_policy" "api_invocation_policy" {
  name = "api_invocation_policy"
  role = aws_iam_role.api_invocation_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "execute-api:Invoke",
          "execute-api:ManageConnections"
        ]
        Resource = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*"
      }
    ]
  })
}
