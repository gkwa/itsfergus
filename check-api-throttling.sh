#!/usr/bin/env bash
set -euo pipefail

TIMESPAN=${1:-5m}
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
    echo "Error: Duration must be in format like '5m' or '1h'"
    exit 1
fi

start_time=$(date -u -d "$MINUTES minutes ago" '+%Y-%m-%dT%H:%M:%SZ')

echo "Checking for API throttling events in the last $TIMESPAN..."

aws cloudtrail lookup-events \
    --region ca-central-1 \
    --start-time "$start_time" \
    --lookup-attributes AttributeKey=EventName,AttributeValue=CreateFunction \
    --query 'Events[?ErrorCode!=`null`].{Time:EventTime,Action:EventName,Error:ErrorCode,Message:ErrorMessage}' \
    --output table

aws cloudtrail lookup-events \
    --region ca-central-1 \
    --start-time "$start_time" \
    --lookup-attributes AttributeKey=EventName,AttributeValue=CreateRestApi \
    --query 'Events[?ErrorCode!=`null`].{Time:EventTime,Action:EventName,Error:ErrorCode,Message:ErrorMessage}' \
    --output table
