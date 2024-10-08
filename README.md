# Lambda Docker API Gateway

Create an AWS Lambda function in docker container with API Gateway and IAM authorization.

The Lambda function generates and returns random matrix using NumPy as a dummy example.

## Setup

```bash
just # show default rules
just all
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
just destroy-plan
just destroy-apply
```

## Dependencies

- [aws-cli](https://github.com/aws/aws-cli)
- [curl](https://github.com/curl/curl)
- [docker](https://github.com/docker/docker-ce)
- [just](https://github.com/casey/just)
- [pip](https://github.com/pypa/pip)
- [ruff](https://github.com/astral-sh/ruff)
- [terraform](https://github.com/hashicorp/terraform)
- [uv](https://github.com/astral-sh/uv)
