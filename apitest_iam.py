import os

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

except KeyError as e:
    print(f"Missing environment variable: {str(e)}")
except requests.exceptions.RequestException as e:
    print(f"Request failed: {str(e)}")
