#!/usr/bin/env bash
set -euo pipefail

# Source environment variables
set -a
source .env
set +a

# Exit if required variables are missing
if [ -z "${API_URL:-}" ] || [ -z "${API_KEY:-}" ]; then
    echo "Error: Required environment variables not set"
    exit 1
fi

echo "Testing API Gateway with API Key auth..."
response=$(curl -s -H "x-api-key: $API_KEY" "$API_URL")
echo "Response: $response"

# Exit with success if response contains expected content
if echo "$response" | grep -q "matrix"; then
    exit 0
else
    echo "Error: Unexpected response"
    exit 1
fi
