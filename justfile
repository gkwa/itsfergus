set shell := ["bash", "-xuc"]
set export := true

aws_region := env_var_or_default("AWS_REGION", "ca-central-1")

default:
    @just --list

setup: deploy curl-test

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
    terraform plan -out=tfplan -var="aws_region={{ aws_region }}"

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
    terraform plan -destroy -out=destroy.tfplan -var="aws_region={{ aws_region }}"

destroy-apply: destroy-plan
    terraform apply destroy.tfplan

get-creds:
    #!/usr/bin/env bash
    set -euo pipefail
    set -x

    export API_INVOCATION_ROLE=$(terraform output -raw api_invocation_role_arn)
    echo "Getting temporary credentials..."

    export CREDS=$(aws sts assume-role --role-arn $API_INVOCATION_ROLE --role-session-name test-session)

    echo "AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)" >.env
    echo "AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)" >> .env
    echo "AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)" >> .env
    echo "AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)" >> .env
    echo "AWS_REGION=$(terraform output -raw aws_region)" >> .env
    echo "API_URL=$(terraform output -raw api_gateway_url)" >> .env

curl-test: get-creds
    #!/usr/bin/env bash
    set -euo pipefail
    set -x

    set -a # make env vars avail to subprocesses
    source .env
    set +a
    uv sync
    . .venv/bin/activate
    python apitest.py

logs:
    #!/usr/bin/env bash
    set -euo pipefail
    set -x
    FUNCTION_NAME=$(terraform output -raw lambda_function_name)
    aws logs tail /aws/lambda/$FUNCTION_NAME --follow --region {{ aws_region }}

cleanup:
    rm -f tfplan destroy.tfplan .env

fmt:
    ruff format .
    ruff check --fix
    terraform fmt -recursive .
    just --unstable --fmt
