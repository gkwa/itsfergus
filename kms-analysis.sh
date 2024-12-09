#!/usr/bin/env bash
set -euo pipefail

# Function to format date for better readability
format_date() {
    local date_str=$1
    if [[ $date_str == "null" ]]; then
        echo "Never"
    else
        echo "$date_str"
    fi
}

# Get all KMS keys
echo "Fetching KMS keys..."
keys=$(aws kms list-keys --output json | jq -r '.Keys[].KeyId')

# Print header
printf "\n%-50s %-25s %-25s %-25s %s\n" "Key ID" "Alias" "Creation Date" "Last Used" "Description"
printf "%s\n" "$(printf '=%.0s' {1..140})"

# Loop through each key
while IFS= read -r key_id; do
    # Get key details
    key_info=$(aws kms describe-key --key-id "$key_id")

    # Get alias if it exists
    alias=$(aws kms list-aliases --key-id "$key_id" --output json |
        jq -r '.Aliases[0].AliasName // "No alias"')

    # Get creation date
    creation_date=$(echo "$key_info" | jq -r '.KeyMetadata.CreationDate')

    # Get last used date using correct API call
    last_used_info=$(aws kms GetKeyLastUsed --key-id "$key_id" --output json 2>/dev/null || echo '{"LastUsedDate": null}')
    last_used_date=$(echo "$last_used_info" | jq -r '.LastUsedDate // "null"')

    # Get description
    description=$(echo "$key_info" | jq -r '.KeyMetadata.Description // "No description"')

    # Format dates
    formatted_creation=$(format_date "$creation_date")
    formatted_last_used=$(format_date "$last_used_date")

    # Print key information
    printf "%-50s %-25s %-25s %-25s %s\n" \
        "$key_id" \
        "$alias" \
        "$formatted_creation" \
        "$formatted_last_used" \
        "$description"

done <<<"$keys"

echo -e "\nDone!"
