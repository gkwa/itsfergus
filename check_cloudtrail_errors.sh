#!/bin/bash

timearg=${1:-1h}
unit=${timearg: -1}
number=${timearg%[hm]}

case $unit in
   h) time_str="$number hours ago" ;;
   m) time_str="$number minutes ago" ;;
   *) echo "Error: Please specify time with h (hours) or m (minutes) like: 1h or 30m"; exit 1 ;;
esac

start_time=$(date -u -d "$time_str" '+%Y-%m-%dT%H:%M:%SZ')
end_time=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

aws cloudtrail lookup-events \
   --region ca-central-1 \
   --start-time $start_time \
   --end-time $end_time \
   --output json | jq -r '.Events[].CloudTrailEvent |
   fromjson |
   select(.responseElements.Message != null or .errorMessage != null or .errorCode != null) |
   "-------------\nTime: \(.eventTime)\nUser: \(.userIdentity.userName)\nEvent: \(.eventName)\nError: \(.errorCode)\nMessage: \(.errorMessage // .responseElements.Message)\n"'
