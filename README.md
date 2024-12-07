# Lambda Docker API Gateway Auth Example

## Motivation

I want to curl with an auth protected Lambda function that runs from a docker a container.

This project demonstrates how to create and deploy an AWS Lambda function in a Docker container with API Gateway and two different authentication methods:

- [IAM authentication for API Gateway](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_sigv.html)
- [Usage plans with API keys](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html)

The Lambda function generates a random matrix using NumPy as a simple example payload.

## Quick Start

Try both authentication methods:

IAM authentication:

```bash
cd itsfergus
time { just teardown; just setup-iam; }; just apitest-iam
```

API Key authentication:

```bash
cd itsfergus
time { just teardown; just setup-key; }; just apitest-key
```

## Using Just Commands

### View Available Commands

```bash
just --list
```

### Preview Command Execution

Use `--dry-run` to see what a command will do:

```bash
just --dry-run setup-iam
```

Note: Commands prefixed with underscore (e.g., `_init-tf`, `_docker-build`) are internal implementation details and shouldn't be called directly.

## Authentication Examples

### API Key Authentication

After setup, you can make requests using curl. Here's a real example (keys shown are now invalid):

```bash
curl --header 'x-api-key: ODF2NyIwsz3wEgTVcraZ07ksuX1j7e9FaN6qAre0' \
     'https://ugc3ld0fa3.execute-api.ca-central-1.amazonaws.com/prod'
```

When running Hurl tests with `just apitesthurl-key`, you'll see details about the request:

```
* Variables:
*     ECR_REPO: lambda-docker-repo
*     AWS_ACCOUNT_ID: 193048895737
*     API_URL: https://ugc3ld0fa3.execute-api.ca-central-1.amazonaws.com/prod
*     API_KEY: ODF2NyIwsz3wEgTVcraZ07ksuX1j7e9FaN6qAre0
*     API_HOST: ugc3ld0fa3.execute-api.ca-central-1.amazonaws.com/prod
*     AWS_REGION: ca-central-1

* Request:
* GET https://ugc3ld0fa3.execute-api.ca-central-1.amazonaws.com/prod
* x-api-key: ODF2NyIwsz3wEgTVcraZ07ksuX1j7e9FaN6qAre0

* Response Headers:
< HTTP/2 200
< content-type: application/json
< x-amzn-requestid: 1e34bf82-a101-4d8d-9ddc-b62216c91c27
< x-amz-apigw-id: CbrTOG8l4osERZg=
```

The setup creates a `.env` file containing your actual credentials and endpoints.

## Infrastructure Setup Reference

### Setup Commands

```bash
# Show available commands
just

# Deploy and capture logs
time just setup 2>&1 | tee log.txt
python3 redact.py log.txt > log_redacted.txt

# Monitor Lambda execution
just logs
```

### Testing Each Auth Method

```bash
# Test IAM authentication setup
just apitest-iam

# Test API key authentication setup
just apitest-key
```

### Development Tools

```bash
# Format all code files
just fmt
```

## Generated Configuration

The setup process creates a `.env` file with necessary configuration:

- `AWS_PROFILE`: AWS credentials profile (default: "default")
- `AWS_REGION`: AWS region (default: "ca-central-1")
- `ECR_REPO`: ECR repository name
- `LAMBDA_NAME`: Lambda function name
- `API_URL`: Generated API Gateway endpoint
- `API_KEY`: Generated API key (when using key authentication)

## Example API Response

The example Lambda function returns a random matrix:

```json
{
  "message": "Matrix generated successfully",
  "matrix": [
    [0.1882, 0.9042],
    [0.4426, 0.1145]
  ],
  "matrix_string": "[[0.19, 0.9 ],\n [0.44, 0.11]]"
}
```

## Cleanup

Remove all AWS resources and local files:

```bash
just teardown
```

## System Requirements

- AWS CLI
- Docker
- Just command runner
- Terraform
- Python tooling (ruff, uv)
- Hurl HTTP client
- Go (for recur installation)
