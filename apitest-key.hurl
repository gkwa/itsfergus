GET {{API_URL}}
x-api-key: {{API_KEY}}
HTTP 200
[Asserts]
jsonpath "$.message" == "Matrix generated successfully"
jsonpath "$.matrix" isCollection
jsonpath "$.matrix" count == 2
jsonpath "$.matrix_string" matches ".*"
