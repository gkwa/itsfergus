#!/usr/bin/env bash
set -euo pipefail

# Get the KMS key ARN for Lambda
KMS_KEY_ARN=$(aws kms describe-key --key-id alias/aws/lambda --query 'KeyMetadata.Arn' --output text)

# Update Lambda function with KMS key
PAGER=cat aws lambda update-function-configuration \
    --function-name docker-lambda-function \
    --kms-key-arn "$KMS_KEY_ARN"

# Wait for update to complete
PAGER=cat aws lambda wait function-updated \
    --function-name docker-lambda-function
