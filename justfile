set shell := ["bash", "-xuc"]
set export := true

aws_region := env_var_or_default("AWS_REGION", "ca-central-1")
auth_type := env_var_or_default("AUTH_TYPE", "iam")

default:
    @just --list

install-recur:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v recur >/dev/null 2>&1; then
        echo "Installing recur..."
        go install github.com/dbohdan/recur/v2@latest
        if ! grep -q "~/go/bin" ~/.bashrc; then
            echo 'export PATH=~/go/bin:$PATH' >> ~/.bashrc
        fi
        export PATH=~/go/bin:$PATH
    fi

setup: install-recur
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Setting up with auth_type={{ auth_type }}"
    export AUTH_TYPE={{ auth_type }}
    just deploy
    just curl-test

teardown: destroy-plan destroy-apply

build:
    docker build -t lambda-docker:latest .

push:
    #!/usr/bin/env bash
    set -xeuo pipefail

    REPO_URL=$(terraform output -raw ecr_repository_url)
    aws ecr get-login-password --region {{ aws_region }} | docker login --username AWS --password-stdin $REPO_URL
    docker tag lambda-docker:latest $REPO_URL:latest
    docker push $REPO_URL:latest

plan:
    terraform plan -out=tfplan -var="aws_region={{ aws_region }}" -var="auth_type={{ auth_type }}"

apply:
    terraform apply -auto-approve -target=aws_ecr_repository.app_repo
    just build
    just push
    just plan
    terraform apply tfplan

deploy: init apply
    @echo "Deployment complete. To test the API Gateway, run 'just curl-test'"

init:
    terraform init -no-color

destroy-plan:
    terraform plan -destroy -out=destroy.tfplan -var="aws_region={{ aws_region }}" -var="auth_type={{ auth_type }}"

destroy-apply: destroy-plan
    terraform apply destroy.tfplan

get-creds-key:
    #!/usr/bin/env bash
    set -euo pipefail
    set -x

    cat << EOF >.env
    API_KEY=$(terraform output -raw api_key)
    API_URL=$(terraform output -raw api_gateway_url)
    EOF

get-creds-iam:
    #!/usr/bin/env bash
    set -euo pipefail
    set -x

    export API_INVOCATION_ROLE=$(terraform output -raw api_invocation_role_arn)
    echo "Getting temporary credentials..."

    export CREDS=$(aws sts assume-role --role-arn $API_INVOCATION_ROLE --role-session-name test-session)

    cat << EOF >.env
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)
    AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)
    AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)
    AWS_REGION=$(terraform output -raw aws_region)
    API_URL=$(terraform output -raw api_gateway_url)
    EOF

get-creds:
    #!/usr/bin/env bash
    if [[ "{{ auth_type }}" == "iam" ]]; then
        just get-creds-iam
    else
        just get-creds-key
    fi

curl-test-iam: get-creds-iam
    #!/usr/bin/env bash
    set -euo pipefail
    set -x

    uv sync
    . .venv/bin/activate

    if [ -f .env ]; then
             set -a
             source .env
             set +a
    fi

    recur -v --attempts 4 --backoff 3s python apitest_iam.py

curl-test-key: get-creds-key
    #!/usr/bin/env bash
    set -euo pipefail
    set -x

    uv sync
    . .venv/bin/activate

    if [ -f .env ]; then
        set -a
        source .env
        set +a
    fi

    recur -v --attempts 4 --backoff 3s python apitest_key.py

curl-test:
    #!/usr/bin/env bash
    if [[ "{{ auth_type }}" == "iam" ]]; then
        just curl-test-iam
    else
        just curl-test-key
    fi

logs:
    #!/usr/bin/env bash
    set -euo pipefail
    set -x
    FUNCTION_NAME=$(terraform output -raw lambda_function_name)
    aws logs tail /aws/lambda/$FUNCTION_NAME --follow --region {{ aws_region }}

cleanup:
    rm -f tfplan destroy.tfplan .env

fmt:
    prettier --ignore-path=.prettierignore --config=.prettierrc.json --write .
    ruff format .
    ruff check --fix
    terraform fmt -recursive .
    just --unstable --fmt

switch-auth:
    #!/usr/bin/env bash
    set -euo pipefail

    if [[ "{{ auth_type }}" == "iam" ]]; then
        export AUTH_TYPE=key
    else
        export AUTH_TYPE=iam
    fi

    echo "Switched to $AUTH_TYPE authentication"
    just deploy
