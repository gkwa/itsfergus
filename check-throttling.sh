#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 -d <duration> [-r <region>]"
    echo "Duration format: <number>[m|h] (e.g., 20m for 20 minutes, 1h for 1 hour)"
    echo "Region is optional (defaults to ca-central-1)"
    exit 1
}

# Parse command line arguments
while getopts "d:r:h" opt; do
    case $opt in
    d) DURATION="$OPTARG" ;;
    r) REGION="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
    esac
done

# Check if duration is provided
if [ -z "$DURATION" ]; then
    usage
fi

# Set default region if not specified
REGION=${REGION:-ca-central-1}

# Extract number and unit from duration
NUMBER=${DURATION%[mh]}
UNIT=${DURATION#$NUMBER}

# Get duration in minutes
get_duration_minutes() {
    if [ "$UNIT" = "h" ]; then
        echo $((NUMBER * 60))
    elif [ "$UNIT" = "m" ]; then
        echo "$NUMBER"
    else
        echo "Invalid duration unit. Use 'm' for minutes or 'h' for hours."
        exit 1
    fi
}

# Calculate start time based on duration
get_start_time() {
    local minutes=$1
    # Handle both GNU date (Linux) and BSD date (macOS)
    if date --version 2>&1 | grep -q 'GNU coreutils'; then
        # Linux
        date -u --date="$minutes minutes ago" "+%Y-%m-%dT%H:%M:00Z"
    else
        # macOS
        date -u -v-${minutes}M "+%Y-%m-%dT%H:%M:00Z"
    fi
}

DURATION_MINS=$(get_duration_minutes)
START_TIME=$(get_start_time "$DURATION_MINS")
END_TIME=$(date -u "+%Y-%m-%dT%H:%M:00Z")

# Convert UTC to PST for display
get_pst_time() {
    local utc_time=$1
    if date --version 2>&1 | grep -q 'GNU coreutils'; then
        # Linux
        TZ='America/Los_Angeles' date --date="$utc_time" '+%Y-%m-%d %H:%M:%S %Z'
    else
        # macOS
        TZ='America/Los_Angeles' date -j -f '%Y-%m-%dT%H:%M:%SZ' "$utc_time" '+%Y-%m-%d %H:%M:%S %Z'
    fi
}

START_PST=$(get_pst_time "$START_TIME")
END_PST=$(get_pst_time "$END_TIME")

# Set PAGER to cat to avoid pagination
export PAGER=cat

echo "Checking for throttling events for the last $DURATION ($DURATION_MINS minutes)"
echo "Time range: $START_PST to $END_PST"
echo "Region: $REGION"
echo

# Check CloudTrail logs
echo "Checking CloudTrail for throttling events..."
aws cloudtrail lookup-events \
    --region "$REGION" \
    --start-time "$START_TIME" \
    --end-time "$END_TIME" \
    --query 'Events[?ErrorCode==`ThrottlingException`].[EventTime,CloudTrailEvent]' \
    --output table

# Additional check for Rate Exceeded errors
echo -e "\nChecking CloudTrail for Rate Exceeded errors..."
aws cloudtrail lookup-events \
    --region "$REGION" \
    --start-time "$START_TIME" \
    --end-time "$END_TIME" \
    --query 'Events[?ErrorCode==`RateExceeded`].[EventTime,CloudTrailEvent]' \
    --output table

# Check CloudWatch Metrics
echo -e "\nChecking CloudWatch Metrics for Throttling..."
aws cloudwatch get-metric-statistics \
    --region "$REGION" \
    --namespace AWS/MTM \
    --metric-name ThrottledCount \
    --dimensions Name=Action,Value=* \
    --start-time "$START_TIME" \
    --end-time "$END_TIME" \
    --period 300 \
    --statistics Sum \
    --output table
