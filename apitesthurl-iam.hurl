GET {{API_URL}}
Host: {{API_HOST}}
x-amz-date: {{DateTime}}
x-amz-security-token: {{AWS_SESSION_TOKEN}}

[Options]
aws-sigv4: aws:amz:{{AWS_REGION}}:execute-api
user: {{AWS_ACCESS_KEY_ID}}:{{AWS_SECRET_ACCESS_KEY}}
HTTP 200

[Asserts]
jsonpath "$.message" == "Matrix generated successfully"
jsonpath "$.matrix" isCollection
jsonpath "$.matrix" count == 2
jsonpath "$.matrix_string" matches ".*"
