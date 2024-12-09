#!/bin/bash

# Usage: ./list-keys.sh 10m/20h (default: 12h)
duration=${1:-12h}
num=${duration%[hm]}
unit=${duration#${num}}

if [[ $unit == "m" ]]; then
    hours=$(bc <<<"scale=2; $num/60")
else
    hours=$num
fi

echo "KMS Keys found in logs since ${duration} ago:"

PAGER=cat aws cloudtrail lookup-events \
    --region ca-central-1 \
    --start-time "$(date -u -d "${hours} hours ago" '+%Y-%m-%dT%H:%M:%SZ')" \
    --query 'Events[?EventSource==`kms.amazonaws.com`].Resources[*].ResourceName' \
    --output text | tr '\t' '\n' | sort -u
