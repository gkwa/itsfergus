#!/usr/bin/env bash
set -euo pipefail

echo "Checking all KMS grants related to project..."

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

# Get all KMS keys
keys=$(aws kms list-keys --query 'Keys[*].KeyId' --output text)

for key_id in $keys; do
    # Get grants that match our Lambda patterns
    aws kms list-grants --key-id "$key_id" --output json | jq -r --arg pattern "lambda|docker-lambda" '
        .Grants[] |
        select(.GranteePrincipal | test($pattern; "i")) |
        [
            .CreationDate,
            .GrantId,
            .GranteePrincipal,
            (.Operations | join(","))
        ] | @tsv
    ' | while IFS=$'\t' read -r date grantid principal ops; do
        if [ ! -z "$date" ]; then # Only process if we found matching grants
            # Get key alias for reference
            alias=$(aws kms list-aliases --key-id "$key_id" --query 'Aliases[0].AliasName' --output text)

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
        fi
    done
done
