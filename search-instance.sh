#!/usr/bin/env bash
PAGER=cat aws logs describe-log-streams \
    --region ca-central-1 \
    --log-group-name /aws/lambda/docker-lambda-function \
    --order-by LastEventTime \
    --descending
