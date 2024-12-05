import os
import sys

import requests
import requests_aws4auth

try:
   auth = requests_aws4auth.AWS4Auth(
       os.environ["AWS_ACCESS_KEY_ID"],
       os.environ["AWS_SECRET_ACCESS_KEY"],
       os.environ["AWS_REGION"],
       "execute-api",
       session_token=os.environ["AWS_SESSION_TOKEN"],
   )

   response = requests.get(os.environ["API_URL"], auth=auth)
   print(response.text)

   # Exit 0 for success (2xx), status code otherwise
   if 200 <= response.status_code < 300:
       sys.exit(0)
   sys.exit(response.status_code)

except KeyError as e:
   print(f"Missing environment variable: {str(e)}")
   sys.exit(1)
except requests.exceptions.RequestException as e:
   print(f"Request failed: {str(e)}")
   sys.exit(1)
