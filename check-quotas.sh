#!/usr/bin/env bash

REGION=${REGION:-ca-central-1}
FUNCTION_NAME=docker-lambda-function

# Cross-platform date command for both macOS and Linux
get_past_time() {
    minutes=$1
    if date -v-${minutes}M &>/dev/null; then
        # macOS
        date -u -v-${minutes}M '+%Y-%m-%dT%H:%M:%SZ'
    else
        # Linux
        date -u -d "${minutes} minutes ago" '+%Y-%m-%dT%H:%M:%SZ'
    fi
}

echo "Checking Lambda quotas and limits..."

# Check Lambda concurrent executions usage
echo -e "\nLambda Concurrent Executions:"
aws lambda get-account-settings --region $REGION --query 'AccountLimit.{ConcurrentExecutions:ConcurrentExecutions,UnreservedConcurrentExecutions:UnreservedConcurrentExecutions}'

# Check Lambda throttling
echo -e "\nLambda throttling in the last hour:"
aws cloudwatch get-metric-statistics \
    --namespace AWS/Lambda \
    --metric-name Throttles \
    --dimensions Name=FunctionName,Value=$FUNCTION_NAME \
    --start-time $(get_past_time 60) \
    --end-time $(date -u '+%Y-%m-%dT%H:%M:%SZ') \
    --period 3600 \
    --statistics Sum \
    --region $REGION

# Check recent API calls to Lambda service
echo -e "\nRecent Lambda API calls (last 15 minutes):"
aws cloudtrail lookup-events \
    --region $REGION \
    --lookup-attributes AttributeKey=ResourceName,AttributeValue=$FUNCTION_NAME \
    --start-time $(get_past_time 15) \
    --query 'Events[].{Time:EventTime,Action:EventName}' \
    --output table

# Check IAM API throttling events
echo -e "\nRecent IAM API throttling events (last 15 minutes):"
aws cloudtrail lookup-events \
    --region $REGION \
    --start-time $(get_past_time 15) \
    --query 'Events[?ErrorCode!=`null`].{Time:EventTime,Action:EventName,Error:ErrorCode,Message:ErrorMessage}' \
    --output table
