#!/usr/bin/env bash
duration=${1:-12h}
num=${duration%[hm]}
unit=${duration#${num}}

if [[ $unit == "m" ]]; then
    mins="-${num} minutes"
else
    mins="-${num} hours"
fi

echo "KMS Keys found in logs since ${duration} ago:"

PAGER=cat aws cloudtrail lookup-events \
    --region ca-central-1 \
    --start-time "$(date -u -d "${mins}" '+%Y-%m-%dT%H:%M:%SZ')" \
    --query 'Events[?EventSource==`kms.amazonaws.com`].Resources[*].ResourceName' \
    --output text | tr '\t' '\n' | sort -u
