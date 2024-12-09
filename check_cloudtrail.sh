#!/bin/bash

minutes=${1%m}
start_time=$(date -u -d "${minutes} minutes ago" '+%Y-%m-%dT%H:%M:%SZ')
end_time=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

aws cloudtrail lookup-events \
    --region ca-central-1 \
    --lookup-attributes AttributeKey=Username,AttributeValue=mtm \
    --start-time $start_time \
    --end-time $end_time \
    --query 'Events[?EventName != `LookupEvents`].{Time:EventTime,User:Username,Event:EventName,Resource:Resources[0].ResourceName,Region:AwsRegion,ErrorCode:ErrorCode,ErrorMessage:ErrorMessage}' \
    --output table
