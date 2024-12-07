import os
import sys

import requests
import requests_aws4auth


def debug_request(auth, url):
    req = requests.Request("GET", url).prepare()
    auth(req)

    # Generate curl command exactly matching Python request
    headers = [f"-H '{k}: {v}'" for k, v in req.headers.items()]
    curl_cmd = f"curl -s {' '.join(headers)} '{url}'"

    print("\nDebug Info:")
    for header, value in req.headers.items():
        print(f"{header}: {value}")

    print("\nCurl command:")
    print(curl_cmd)


try:
    auth = requests_aws4auth.AWS4Auth(
        os.environ["AWS_ACCESS_KEY_ID"],
        os.environ["AWS_SECRET_ACCESS_KEY"],
        os.environ["AWS_REGION"],
        "execute-api",
        session_token=os.environ["AWS_SESSION_TOKEN"],
    )

    url = os.environ["API_URL"]
    debug_request(auth, url)

    response = requests.get(url, auth=auth)
    print(f"\nStatus Code: {response.status_code}")
    print(f"Response: {response.text}")

    sys.exit(0 if 200 <= response.status_code < 300 else response.status_code)

except KeyError as e:
    print(f"Missing environment variable: {str(e)}")
    sys.exit(1)
except requests.exceptions.RequestException as e:
    print(f"Request failed: {str(e)}")
    sys.exit(1)
