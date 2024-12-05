# List available recipes
default:
    @just --list

# Setup variables
AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")
AWS_REGION := env_var_or_default("AWS_REGION", "ca-central-1")
ECR_REPO := "lambda-docker-repo"
LAMBDA_NAME := "docker-lambda-function"

# Initialize environment variables
_init-env AUTH_TYPE:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -f .env ]; then
        echo "Creating .env file..."

        # Get account ID
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

        # Get API URL from terraform output
        API_URL=$(terraform output -raw api_gateway_url)

        # Create env file
        echo "AWS_REGION={{AWS_REGION}}" > .env
        echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID" >> .env
        echo "ECR_REPO={{ECR_REPO}}" >> .env
        echo "API_URL=$API_URL" >> .env

        if [ "{{AUTH_TYPE}}" = "key" ]; then
            API_KEY=$(terraform output -raw api_key)
            echo "API_KEY=$API_KEY" >> .env
        fi
    fi

# Build and push Docker image
_docker-build:
    #!/usr/bin/env bash
    set -euo pipefail
    source .env

    aws ecr get-login-password --region $AWS_REGION | \
        docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

    docker build -t $ECR_REPO .
    docker tag $ECR_REPO:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest

# Initialize terraform
_tf-init:
    terraform init -upgrade

# Apply terraform with IAM auth
_tf-apply-iam:
    terraform apply -auto-approve -var="auth_type=iam"

# Apply terraform with Key auth
_tf-apply-key:
    terraform apply -auto-approve -var="auth_type=key"

# Destroy terraform with IAM auth
_tf-destroy-iam:
    terraform destroy -auto-approve -var="auth_type=iam"

# Destroy terraform with Key auth
_tf-destroy-key:
    terraform destroy -auto-approve -var="auth_type=key"

# Deploy infrastructure with IAM auth
setup-iam: _tf-init _tf-apply-iam _docker-build (_init-env "iam")

# Deploy infrastructure with API Key auth
setup-key: _tf-init _tf-apply-key _docker-build (_init-env "key")

# Destroy infrastructure with IAM auth
destroy-iam: _tf-destroy-iam

# Destroy infrastructure with API Key auth
destroy-key: _tf-destroy-key

# Test the API endpoint
curl-test:
    #!/usr/bin/env bash
    set -euo pipefail
    source .env

    if [ -v API_KEY ]; then
        python apitest_key.py
    else
        python apitest_iam.py
    fi

# View CloudWatch logs
logs:
    aws logs tail "/aws/lambda/{{LAMBDA_NAME}}" --since 1h --follow
