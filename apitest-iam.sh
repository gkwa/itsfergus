#!/usr/bin/env bash
set -euo pipefail

set -a
source .env
set +a

# Request details
date=$(date -u +%Y%m%dT%H%M%SZ)
datestamp=${date%T*}
host=$API_HOST
empty_hash=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

# Generate signing key using hex encoding for consistent handling
key="AWS4$AWS_SECRET_ACCESS_KEY"

# Use hex encoding for key derivation to avoid binary string issues
k_date=$(echo -n "$datestamp" | openssl dgst -sha256 -hex -mac HMAC -macopt "hexkey:$(echo -n "$key" | xxd -p | tr -d '\n')" | sed 's/.* //')
k_region=$(echo -n "$AWS_REGION" | openssl dgst -sha256 -hex -mac HMAC -macopt "hexkey:$k_date" | sed 's/.* //')
k_service=$(echo -n "execute-api" | openssl dgst -sha256 -hex -mac HMAC -macopt "hexkey:$k_region" | sed 's/.* //')
k_signing=$(echo -n "aws4_request" | openssl dgst -sha256 -hex -mac HMAC -macopt "hexkey:$k_service" | sed 's/.* //')

# Create canonical request
canonical_request=$(
    cat <<EOF
GET
/

host:$host
user-agent:hurl/6.0.0
x-amz-date:$date
x-amz-security-token:$AWS_SESSION_TOKEN

host;user-agent;x-amz-date;x-amz-security-token
$empty_hash
EOF
)

# Create string to sign
credential_scope="$datestamp/$AWS_REGION/execute-api/aws4_request"
string_to_sign=$(
    cat <<EOF
AWS4-HMAC-SHA256
$date
$credential_scope
$(echo -n "$canonical_request" | openssl sha256 -hex | sed 's/.* //')
EOF
)

# Calculate signature
signature=$(echo -n "$string_to_sign" | openssl dgst -sha256 -hex -mac HMAC -macopt "hexkey:$k_signing" | sed 's/.* //')

# Make signed request
curl --silent \
    --header "Host: $host" \
    --header "Authorization: AWS4-HMAC-SHA256 Credential=$AWS_ACCESS_KEY_ID/$credential_scope, SignedHeaders=host;user-agent;x-amz-date;x-amz-security-token, Signature=$signature" \
    --header "Accept: */*" \
    --header "x-amz-date: $date" \
    --header "x-amz-security-token: $AWS_SESSION_TOKEN" \
    --header "User-Agent: hurl/6.0.0" \
    "$API_URL"
