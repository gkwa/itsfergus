#!/usr/bin/env bash

# Function to validate ISO8601 timestamp
is_timestamp() {
    [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

# Function to get relative time in minutes
get_relative_time() {
    local timestamp=$1
    local now=$(date -u +%s)
    local then=$(date -u -d "$timestamp" +%s)
    local diff_mins=$(((now - then) / 60))

    if [ $diff_mins -lt 0 ]; then
        echo "in $((-diff_mins))m"
    else
        echo "${diff_mins}m ago"
    fi
}

# Default duration is 30 minutes if not specified
if [ -z "$1" ]; then
    DURATION=30
    START_TIME=$(date -u -d "${DURATION} minutes ago" +"%Y-%m-%dT%H:%M:%SZ")
elif is_timestamp "$1"; then
    START_TIME=$1
else
    # Remove 'm' or 'min' suffix if present and use as duration
    DURATION=${1//[^0-9]/}
    START_TIME=$(date -u -d "${DURATION} minutes ago" +"%Y-%m-%dT%H:%M:%SZ")
fi

END_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
START_RELATIVE=$(get_relative_time "$START_TIME")
END_RELATIVE=$(get_relative_time "$END_TIME")

echo "Searching from: ${START_TIME} (${START_RELATIVE})"
echo "          to:   ${END_TIME} (${END_RELATIVE})"
echo "---"

aws cloudtrail --region ca-central-1 lookup-events \
    --lookup-attributes AttributeKey=Username,AttributeValue=mtm \
    --start-time "${START_TIME}" \
    --end-time "${END_TIME}" \
    --query 'Events[?contains(CloudTrailEvent, `error`) || contains(CloudTrailEvent, `Error`) || contains(CloudTrailEvent, `exception`) || contains(CloudTrailEvent, `Exception`)]' \
    --output json |
    jq -r '.[] | .CloudTrailEvent | fromjson |
    select(.errorMessage != null and .errorMessage != "Rate exceeded") |
    "\(.eventTime) \(.eventName): \(.errorMessage)"' |
    head -n 10
