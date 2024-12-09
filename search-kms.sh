#!/usr/bin/env bash

# Usage: ./search-kms.sh 10m/20h (default: 12h)
duration=${1:-12h}
num=${duration%[hm]}
unit=${duration#${num}}

if [[ $unit == "m" ]]; then
    hours=$(bc <<<"scale=2; $num/60")
else
    hours=$num
fi

PAGER=cat aws logs describe-log-streams \
    --region ca-central-1 \
    --log-group-name "/aws/lambda/docker-lambda-function"

PAGER=cat aws cloudtrail lookup-events \
    --region ca-central-1 \
    --lookup-attributes AttributeKey=EventSource,AttributeValue=kms.amazonaws.com \
    --start-time "$(date -u -d "${hours} hours ago" '+%Y-%m-%dT%H:%M:%SZ')"
