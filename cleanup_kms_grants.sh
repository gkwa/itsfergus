#!/usr/bin/env bash
set -euo pipefail

region=ca-central-1
account_id=$(aws sts get-caller-identity --query Account --output text)

for alias in "alias/aws/lambda" "alias/aws/ecr"; do
    key_id=$(aws kms describe-key --key-id "$alias" --query 'KeyMetadata.KeyId' --output text)
    key_arn="arn:aws:kms:${region}:${account_id}:key/${key_id}"
    grants=$(aws kms list-grants --key-id "$key_id" --query 'Grants[].GrantId' --output text)

    if [ ! -z "$grants" ]; then
        for grant in $grants; do
            aws kms retire-grant --key-id "$key_arn" --grant-id "$grant"
        done
    fi
done
