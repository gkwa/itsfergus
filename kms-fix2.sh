#!/usr/bin/env bash

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors

FUNCTION_NAME=docker-lambda-function
REGION=ca-central-1

CURRENT_KEY=$(aws --region $REGION lambda get-function-configuration --function-name $FUNCTION_NAME | jq -r '.KMSKeyArn')

aws --region $REGION lambda update-function-configuration --function-name $FUNCTION_NAME --kms-key-arn ""
sleep 10

aws --region $REGION lambda update-function-configuration --function-name $FUNCTION_NAME --kms-key-arn "$CURRENT_KEY"
sleep 10
