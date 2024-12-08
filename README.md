# Lambda Docker API Gateway Auth Example

## Motivation

I want to be able to curl an auth protected Lambda function that runs from a docker a container.

## Rant

This project is the result of many iterations with Claude.ai.

Its tricky and time consuing to learn this stuff. This terraform gives me starting point to tinker further.

Just give me an example already and let me fiddle with it to understand it!

I know nothing about AWS API Gateway, but I want to. I don't want to start learning by googling snippets and trying to piece together stuff I know nothing about. Its not productive.

I see a lot of tutorials that don't provide working code.

I don't want to read a wall of text and think about theory, I want hands on from the start please.

Then, later after running your code and seeing that that it works, I can trust that spending time with your code is woth it.

Medium articles are helpful in that they give you a hint that something is possible, but you're on your own to iterate to a working solution.

Fine, yes, we should pay the price (time) to learn something, but not by googling for examples forever.

This terraform puts the gateway, lambda function, docker container in place so I can tweak it and observe the change and compare that to the AWS docs.

## Description

Its a reminder for how to create and deploy an AWS Lambda function in a Docker container with API Gateway and two different authentication methods:

- [IAM authentication for API Gateway](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_sigv.html)
- [Usage plans with API keys](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html)

The Lambda function generates a random matrix using NumPy as a simple example payload.

I started this journey after finding [pixegami](https://www.youtube.com/c/pixegami)'s great youtube [tutorial](https://www.youtube.com/watch?v=wbsbXfkv47A).

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

## Generated Configuration

The setup process creates a `.env` file with different configurations based on the authentication method:

### For API Key Authentication

```
# .env
AWS_ACCOUNT_ID=123456789012
AWS_REGION=ca-central-1
ECR_REPO=lambda-docker-repo
API_URL=https://76853b6ipk.execute-api.ca-central-1.amazonaws.com/prod
API_HOST=76853b6ipk.execute-api.ca-central-1.amazonaws.com/prod
API_KEY=FPXs1bXY35axVFfbU2zPs7wUNQXfiiUj1lmYBI1W
```

### For IAM Authentication

```
# .env
AWS_ACCESS_KEY_ID=ASIASZ4U4MD4WOQ4V22O
AWS_SECRET_ACCESS_KEY=n9+Hjywl5SJFm0iDrf6Qr9VqMTWkGG48sCUUA/EE
AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEJL//////////wEaDGNhLWNlbnRyYWwtMSJHMEUCIQCvHk5UCm5NOGC2hU6cAX4nABGwF0I3x+zf0LoJ0AER5QIgOwXECMJeWfBust9eybrx9Qdrznm9kFS0r6OGzBem/tIqmQIITBAAGgwxOTMwNDg4OTU3MzciDLvhQq2W3YXH5r7Z6Cr2AXskdmikMi2UOcyKHblqBkc0pqbod35LBaqoHyU3EbhKyQ4jizT92rveDIDUtP9X1dqvE4S/s950pncWrd4L4T58H6wnN9Uh83pJpbxh5OhovgYZtl3HZjcbvTacv3aAUCBrylxD1BKFw4ogDmPiCurtVxSXqrRBThxYlfMRzEEOquDPXbVk57vo20JSE5WFBBeXkcQHPKdRgn8CdeAHROCjtSp3VhDy5AZxzYrslVeY3dI2RLOI30PTbPMeMISF10LwduMhEn9jCWkWKl2xqaf9IsCBdGun9qwAH6e6ZwP0nwr81bUH4zxxh/yNzJMMIH6sEfqUyDCLp9K6BjqdAUdmIDGbn++5xlS+Z9xI9l9u+TvOXBH052Fx0041C7kVH+x3tjU5jlFTuMGr5RYj9YebxZq1Xbm8GHEh865AhKTd8b3PiEa4HJyGJqnKfDUss7tin6YkAX/sboV3xdI4NTP3e2zL++Q4FZZZrwTqp7sCja4QgMj3CwwtNnPMOWrMUHGS6PYgVImQ6Kxy92B1iiO1M8r2WmWLPA9ples=
AWS_ACCOUNT_ID=123456789012
AWS_REGION=ca-central-1
ECR_REPO=lambda-docker-repo
API_URL=https://oordw5fnzh.execute-api.ca-central-1.amazonaws.com/
API_HOST=oordw5fnzh.execute-api.ca-central-1.amazonaws.com
```

That .env along with [`apitest-iam.sh`](./apitest-iam.sh) results in this monstrosity:

```bash
curl --silent \
  --header 'Host: oordw5fnzh.execute-api.ca-central-1.amazonaws.com' \
  --header 'Authorization: AWS4-HMAC-SHA256 Credential=ASIASZ4U4MD4WOQ4V22O/20241207/ca-central-1/execute-api/aws4_request, SignedHeaders=host;user-agent;x-amz-date;x-amz-security-token, Signature=a77a3b18087159e3b360de0a156d59e43aeb67ffe4d4e829b6d17c40341d26c2' \
  --header 'Accept: */*' \
  --header 'x-amz-date: 20241207T183535Z' \
  --header 'x-amz-security-token: IQoJb3JpZ2luX2VjEJL//////////wEaDGNhLWNlbnRyYWwtMSJHMEUCIQCvHk5UCm5NOGC2hU6cAX4nABGwF0I3x+zf0LoJ0AER5QIgOwXECMJeWfBust9eybrx9Qdrznm9kFS0r6OGzBem/tIqmQIITBAAGgwxOTMwNDg4OTU3MzciDLvhQq2W3YXH5r7Z6Cr2AXskdmikMi2UOcyKHblqBkc0pqbod35LBaqoHyU3EbhKyQ4jizT92rveDIDUtP9X1dqvE4S/s950pncWrd4L4T58H6wnN9Uh83pJpbxh5OhovgYZtl3HZjcbvTacv3aAUCBrylxD1BKFw4ogDmPiCurtVxSXqrRBThxYlfMRzEEOquDPXbVk57vo20JSE5WFBBeXkcQHPKdRgn8CdeAHROCjtSp3VhDy5AZxzYrslVeY3dI2RLOI30PTbPMeMISF10LwduMhEn9jCWkWKl2xqaf9IsCBdGun9qwAH6e6ZwP0nwr81bUH4zxxh/yNzJMMIH6sEfqUyDCLp9K6BjqdAUdmIDGbn++5xlS+Z9xI9l9u+TvOXBH052Fx0041C7kVH+x3tjU5jlFTuMGr5RYj9YebxZq1Xbm8GHEh865AhKTd8b3PiEa4HJyGJqnKfDUss7tin6YkAX/sboV3xdI4NTP3e2zL++Q4FZZZrwTqp7sCja4QgMj3CwwtNnPMOWrMUHGS6PYgVImQ6Kxy92B1iiO1M8r2WmWLPA9ples=' \
  --header 'User-Agent: hurl/6.0.0' \
  https://oordw5fnzh.execute-api.ca-central-1.amazonaws.com/
```

but gives the expected response:

```json
{
  "message": "Matrix generated successfully",
  "matrix": [
    [0.1989188846757185, 0.9292142971834155],
    [0.7873764687384766, 0.7633609115232858]
  ],
  "matrix_string": "[[0.2 , 0.93],\n [0.79, 0.76]]"
}
```

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

## Dependencies

- [aws-cli](https://github.com/aws/aws-cli?tab=readme-ov-file#aws-cli)
- [curl](https://github.com/curl/curl?tab=readme-ov-file)
- [docker](https://www.docker.com/)
- [Go](https://github.com/golang/go?tab=readme-ov-file#the-go-programming-language)
- [Hurl](https://github.com/Orange-OpenSource/hurl?tab=readme-ov-file#whats-hurl)
- [just](https://github.com/casey/just?tab=readme-ov-file#just)
- [ruff](https://github.com/astral-sh/ruff?tab=readme-ov-file#ruff)
- [terraform](https://github.com/hashicorp/terraform?tab=readme-ov-file#terraform)
- [uv](https://github.com/astral-sh/uv?tab=readme-ov-file#uv)
