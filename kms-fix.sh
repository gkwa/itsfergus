#!/usr/bin/env bash

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
set -e

FUNCTION_NAME=docker-lambda-function
REGION=ca-central-1

CURRENT_ROLE=$(aws --region $REGION lambda get-function-configuration --function-name $FUNCTION_NAME | jq -r '.Role')
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

aws iam attach-role-policy \
    --role-name "$TEMP_ROLE_NAME" \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

sleep 10

aws --region $REGION lambda update-function-configuration --function-name $FUNCTION_NAME --role $TEMP_ROLE
sleep 10

aws --region $REGION lambda update-function-configuration --function-name $FUNCTION_NAME --role $CURRENT_ROLE
sleep 10

aws iam detach-role-policy \
    --role-name "$TEMP_ROLE_NAME" \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

aws iam delete-role --role-name "$TEMP_ROLE_NAME"
