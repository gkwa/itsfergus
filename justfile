AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")
AWS_REGION := env_var_or_default("AWS_REGION", "ca-central-1")
ECR_REPO := "lambda-docker-repo"
LAMBDA_NAME := "docker-lambda-function"

default:
    @just --list

setup:
    just setup-iam

setup-iam: _tf-init-ecr _docker-build _tf-apply-iam (_init-env "iam")

setup-key: _tf-init-ecr _docker-build _tf-apply-key (_init-env "key")

destroy-iam: _tf-destroy-iam

destroy-key: _tf-destroy-key

_tf-init-ecr:
    terraform init -upgrade
    terraform apply -auto-approve -target=aws_ecr_repository.app_repo -var="auth_type=iam"

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
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        API_URL=$(terraform output -raw api_gateway_url)
        echo "AWS_REGION={{ AWS_REGION }}" > .env
        echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID" >> .env
        echo "ECR_REPO={{ ECR_REPO }}" >> .env
        echo "API_URL=$API_URL" >> .env
        if [ "{{ AUTH_TYPE }}" = "key" ]; then
            API_KEY=$(terraform output -raw api_key)
            echo "API_KEY=$API_KEY" >> .env
        fi
    fi

_tf-apply-iam:
    terraform apply -auto-approve -var="auth_type=iam"

_tf-apply-key:
    terraform apply -auto-approve -var="auth_type=key"

_tf-destroy-iam:
    terraform destroy -auto-approve -var="auth_type=iam"

_tf-destroy-key:
    terraform destroy -auto-approve -var="auth_type=key"

teardown:
    just destroy-iam

curl-test:
    #!/usr/bin/env bash
    set -euo pipefail
    uv sync
    . .venv/bin/activate
    set -a; source .env; set +a
    if [ -v API_KEY ]; then
        python apitest_key.py
    else
        python apitest_iam.py
    fi

logs:
    aws logs tail "/aws/lambda/{{ LAMBDA_NAME }}" --since 1h --follow

fmt:
    ruff format .
    just --unstable --fmt

lint:
    ruff check .

uv:
    uv pip install -r requirements.txt
