#!/usr/bin/env bash

set -euo pipefail
echo "Checking KMS grants..."

format_age() {
    local age_secs=$1
    if [ $age_secs -ge 3600 ]; then
        echo "$((age_secs / 3600))h $(((age_secs % 3600) / 60))m ago"
    elif [ $age_secs -ge 60 ]; then
        echo "$((age_secs / 60))m ago"
    else
        echo "${age_secs}s ago"
    fi
}

for alias in "alias/aws/lambda" "alias/aws/ecr"; do
    echo -e "\nGrants for $alias:"
    key_id=$(aws kms describe-key --key-id "$alias" --query 'KeyMetadata.KeyId' --output text)

    aws kms list-grants --key-id "$key_id" --output json | jq -r '
        .Grants[] |
        [
            .CreationDate,
            .GrantId,
            .GranteePrincipal,
            (.Operations | join(","))
        ] | @tsv
    ' | while IFS=$'\t' read -r date grantid principal ops; do
        if date -j -f "%Y-%m-%dT%H:%M:%S" >/dev/null 2>&1; then
            then_secs=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${date:0:19}" "+%s")
        else
            then_secs=$(date -d "$date" "+%s")
        fi
        now_secs=$(date "+%s")
        age=$((now_secs - then_secs))
        age_formatted=$(format_age $age)

        echo "grant:"
        echo "  key_alias: $alias"
        echo "  created_at: $date"
        echo "  age: $age_formatted"
        echo "  grant_id: $grantid"
        echo "  principal: $principal"
        echo "  operations: $ops"
        echo
    done
done
