#!/usr/bin/env bash
set -euo pipefail

# Default to 5 minutes if not specified
TIMESPAN=${1:-5m}
TZ=${2:-"America/Los_Angeles"}

export PAGER=cat

# Parse timespan into minutes
if [[ $TIMESPAN =~ ^([0-9]+)([mh])$ ]]; then
    number="${BASH_REMATCH[1]}"
    unit="${BASH_REMATCH[2]}"

    if [ "$unit" = "h" ]; then
        MINUTES=$((number * 60))
    else
        MINUTES=$number
    fi
else
    echo "Error: Timespan must be in format like '5m' or '1h'"
    exit 1
fi

# Get timestamps for CloudWatch (in UTC for AWS API)
end_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
start_time=$(date -u -d "$MINUTES minutes ago" +"%Y-%m-%dT%H:%M:%SZ")

# Convert times to PST for display
end_local=$(TZ=$TZ date -d "$end_time" '+%Y-%m-%d %H:%M:%S %Z')
start_local=$(TZ=$TZ date -d "$start_time" '+%Y-%m-%d %H:%M:%S %Z')

echo "=== KMS Metrics Report ==="
echo "Period: $start_local to $end_local"
echo "Timespan: $TIMESPAN"

# Get Lambda KMS key ID
key_id=$(aws kms describe-key --key-id alias/aws/lambda --query 'KeyMetadata.KeyId' --output text)
echo "Lambda KMS Key ID: $key_id"

echo -e "\n=== Throttling Metrics ==="
aws cloudwatch get-metric-statistics \
    --namespace AWS/KMS \
    --metric-name ThrottleCount \
    --dimensions Name=KeyId,Value="$key_id" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 60 \
    --statistics Sum Average Maximum \
    --output json

echo -e "\n=== Decrypt Operation Metrics ==="
aws cloudwatch get-metric-statistics \
    --namespace AWS/KMS \
    --metric-name Throttles \
    --dimensions Name=Operation,Value=Decrypt \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 60 \
    --statistics Sum Average Maximum \
    --output json

echo -e "\n=== Latency Metrics ==="
aws cloudwatch get-metric-statistics \
    --namespace AWS/KMS \
    --metric-name Latency \
    --dimensions Name=Operation,Value=Decrypt \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 60 \
    --statistics Average Minimum Maximum \
    --output json

echo -e "\n=== Request Count ==="
aws cloudwatch get-metric-statistics \
    --namespace AWS/KMS \
    --metric-name RequestCount \
    --dimensions Name=KeyId,Value="$key_id" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 60 \
    --statistics Sum Average Maximum \
    --output json

# Error metrics are crucial for our investigation
echo -e "\n=== Error Count ==="
aws cloudwatch get-metric-statistics \
    --namespace AWS/KMS \
    --metric-name ErrorCount \
    --dimensions Name=KeyId,Value="$key_id" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 60 \
    --statistics Sum Average Maximum \
    --output json
