# Lambda Docker API Gateway

Create an AWS Lambda function in docker container with API Gateway and IAM authorization.

The Lambda function generates and returns random matrix using NumPy as a dummy example.

## Setup

```bash
just # show default rules
time just setup 2>&1 | tee log.txt
python3 redact.py log.txt >log_redacted.txt
just curl-test
just logs # check cloudwatch logs
```

## Example Output

```bash
+ python apitest.py
{
    "message": "Matrix generated successfully",
    "matrix": [
        [0.1882, 0.9042],
        [0.4426, 0.1145]
    ],
    "matrix_string": "[[0.19, 0.9 ],\n [0.44, 0.11]]"
}
```

## Teardown

```bash
just teardown
rm -f .env
```

## Dependencies

- [aws-cli](https://github.com/aws/aws-cli)
- [curl](https://github.com/curl/curl)
- [docker](https://github.com/docker/docker-ce)
- [just](https://github.com/casey/just)
- [ruff](https://github.com/astral-sh/ruff)
- [terraform](https://github.com/hashicorp/terraform)
- [uv](https://github.com/astral-sh/uv)
- [recur](https://github.com/dbohdan/recur?tab=readme-ov-file#recur)
