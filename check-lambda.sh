#!/usr/bin/env bash

export PAGER=cat

REGION=${REGION:-ca-central-1}

aws lambda list-functions --region $REGION --query 'Functions[*].FunctionName'
