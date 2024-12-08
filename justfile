set export := true

AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")
AWS_REGION := env_var_or_default("AWS_REGION", "ca-central-1")
ECR_REPO := "lambda-docker-repo"
LAMBDA_NAME := "docker-lambda-function"

default:
    @just --list

_init-tf:
    terraform init -upgrade

_tf-init-ecr: _init-tf
    terraform apply -auto-approve -target=aws_ecr_repository.app_repo

setup-iam: _install-recur _tf-init-ecr _docker-build _tf-apply-iam (_init-env "iam") apitestpython-iam

setup-key: _install-recur _tf-init-ecr _docker-build _tf-apply-key (_init-env "key") apitestpython-key

destroy-iam: _init-tf _tf-destroy-iam

destroy-key: _init-tf _tf-destroy-key

_install-recur:
    #!/usr/bin/env bash
    if ! command -v recur >/dev/null 2>&1; then
        GOBIN=/usr/local/bin go install github.com/dbohdan/recur/v2@latest
    fi

_docker-build:
    #!/usr/bin/env bash
    set -euo pipefail
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region {{ AWS_REGION }} | \
        docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com
    docker build -t {{ ECR_REPO }} .
    docker tag {{ ECR_REPO }}:latest $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest

_init-env AUTH_TYPE:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -f .env ]; then
        if [ "{{ AUTH_TYPE }}" = "key" ]; then
            API_KEY=$(terraform output -raw api_key)
            echo "API_KEY=$API_KEY" >> .env
        fi

        if [ "{{ AUTH_TYPE }}" = "iam" ]; then
            ROLE_ARN=$(terraform output -raw api_invocation_role_arn)
            CREDS=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name test-session)
            echo "AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)" > .env
            echo "AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)" >> .env
            echo "AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)" >> .env
        fi

        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        API_URL=$(terraform output -raw api_gateway_url)
        API_HOST=$(echo "$API_URL" | sed 's|^https://||' | sed 's|/$||')
        echo "API_HOST=$API_HOST" >> .env
        echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID" >> .env
        echo "AWS_REGION={{ AWS_REGION }}" >> .env
        echo "ECR_REPO={{ ECR_REPO }}" >> .env
        echo "API_URL=$API_URL" >> .env
    fi

_tf-apply-iam:
    terraform apply -auto-approve -var="auth_type=iam"

_tf-apply-key:
    terraform apply -auto-approve -var="auth_type=key"

_tf-destroy-iam:
    terraform destroy -auto-approve -var="auth_type=iam"

_tf-destroy-key:
    terraform destroy -auto-approve -var="auth_type=key"

_remove_dot_env:
    rm -f .env

teardown: _remove_dot_env destroy-iam destroy-key

apitestpython-key: _install-recur
    #!/usr/bin/env bash
    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-key.py

apitestpython-iam: _install-recur
    #!/usr/bin/env bash
    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-iam.py

apitest-iam: apitesthurl-iam apitestpython-iam apitestbash-iam

apitest-key: apitesthurl-key apitestpython-key apitestbash-key

apitesthurl-key: _install-recur
    #!/usr/bin/env bash
    hurl --retry 10 --jobs 1 --repeat 1 --test --variables-file=.env apitest-key.hurl

apitesthurl-iam:
    #!/usr/bin/env bash
    hurl --retry 10 --jobs 1 --repeat 1 --test --variable "DateTime=$(date -u +%Y%m%dT%H%M%SZ)" --variables-file=.env apitest-iam.hurl

apitestbash-key:
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

apitestbash-iam:
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

logs:
    aws logs tail "/aws/lambda/{{ LAMBDA_NAME }}" --since 1h --follow

fmt:
    shfmt -w -s -i 4 *.sh
    terraform fmt -recursive .
    prettier --ignore-path=.prettierignore --config=.prettierrc.json --write .
    ruff check . --fix
    ruff format .
    just --unstable --fmt
