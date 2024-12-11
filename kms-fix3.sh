#!/usr/bin/env bash

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors

FUNCTION_NAME=docker-lambda-function
REGION=ca-central-1

export PAGER=cat

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Step 1: Switch to default KMS key
aws --region $REGION lambda update-function-configuration \
    --function-name $FUNCTION_NAME --kms-key-arn ""
sleep 10

# Step 2: Reset the role
CURRENT_ROLE=$(
    aws --region $REGION lambda get-function-configuration \
        --function-name $FUNCTION_NAME | jq -r .Role
)
TEMP_ROLE="${CURRENT_ROLE%-role}"-temp-role""
TEMP_ROLE_NAME=$(basename $TEMP_ROLE)

aws iam create-role \
    --role-name "$TEMP_ROLE_NAME" \
    --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }]
    }'

aws iam put-role-policy \
    --role-name "$TEMP_ROLE_NAME" \
    --policy-name "ECRAccess" \
    --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "kms:Decrypt",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
        }
    ]
    }'

sleep 10

aws --region $REGION lambda update-function-configuration \
    --function-name $FUNCTION_NAME --role $TEMP_ROLE
sleep 10

aws --region $REGION lambda update-function-configuration \
    --function-name $FUNCTION_NAME --role $CURRENT_ROLE
sleep 10

# Step 3: Clean up
aws iam delete-role-policy --role-name "$TEMP_ROLE_NAME" --policy-name "ECRAccess"
aws iam delete-role --role-name "$TEMP_ROLE_NAME"

# Step 4: Force new deployment
IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/lambda-docker-repo:latest"
aws --region $REGION lambda update-function-code \
    --function-name $FUNCTION_NAME --image-uri $IMAGE_URI
