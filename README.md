# Lambda Docker API Gateway

Create an AWS Lambda function in docker container with API Gateway and IAM authorization.

The Lambda function generates and returns random matrix using NumPy as a dummy example.

## Setup

```bash
just # show default rules
just setup
sleep 20s # wait for resources to be ready, TODO: fix me
just curl-test
just logs
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
```

## Dependencies

- [aws-cli](https://github.com/aws/aws-cli)
- [curl](https://github.com/curl/curl)
- [docker](https://github.com/docker/docker-ce)
- [just](https://github.com/casey/just)
- [ruff](https://github.com/astral-sh/ruff)
- [terraform](https://github.com/hashicorp/terraform)
- [uv](https://github.com/astral-sh/uv)
