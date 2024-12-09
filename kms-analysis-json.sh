#!/usr/bin/env bash
set -euo pipefail

# Get all KMS keys and output JSON with creation dates and last used info
keys=$(aws kms list-keys --output json | jq -r '.Keys[].KeyId')

echo "["
first=true

while IFS= read -r key_id; do
    if [ "$first" = true ]; then
        first=false
    else
        echo ","
    fi

    # Get key details
    key_info=$(aws kms describe-key --key-id "$key_id")

    # Get alias
    alias=$(aws kms list-aliases --key-id "$key_id" --output json |
        jq -r '.Aliases[0].AliasName // "No alias"')

    # Get last used info using correct API call
    last_used_info=$(aws kms GetKeyLastUsed --key-id "$key_id" --output json 2>/dev/null || echo '{"LastUsedDate": null}')

    # Combine all information into a single JSON object
    jq -n \
        --arg kid "$key_id" \
        --arg alias "$alias" \
        --argjson key_info "$key_info" \
        --argjson last_used "$last_used_info" \
        '{
            keyId: $kid,
            alias: $alias,
            creationDate: $key_info.KeyMetadata.CreationDate,
            description: $key_info.KeyMetadata.Description,
            enabled: $key_info.KeyMetadata.Enabled,
            keyState: $key_info.KeyMetadata.KeyState,
            keyManager: $key_info.KeyMetadata.KeyManager,
            lastUsed: $last_used.LastUsedDate
        }'
done <<<"$keys"

echo "]"
