#!/usr/bin/env bash
duration=${1:-12h}
num=${duration%[hm]}
unit=${duration#${num}}

case $unit in
m)
    mins=$num
    ;;
h)
    mins=$((num * 60))
    ;;
*)
    echo "Invalid duration format. Use <number>h or <number>m (e.g. 3m, 2h)"
    exit 1
    ;;
esac

# GNU date (both Linux and macOS with GNU coreutils)
start_time=$(date -u -d "${mins} minutes ago" '+%Y-%m-%dT%H:%M:%SZ')

PAGER=cat aws logs describe-log-streams \
    --region ca-central-1 \
    --log-group-name "/aws/lambda/docker-lambda-function"

PAGER=cat aws cloudtrail lookup-events \
    --region ca-central-1 \
    --lookup-attributes AttributeKey=EventSource,AttributeValue=kms.amazonaws.com \
    --start-time "$start_time"
