#!/bin/bash

PAGER=cat aws lambda list-functions --region ca-central-1 --query 'Functions[*].FunctionName'
