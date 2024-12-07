import datetime
import os
import sys

import requests

start_time = datetime.datetime.now()

try:
    print(f"\n[{start_time}] Attempt with API Key auth...")

    api_key = os.environ["API_KEY"]
    api_url = os.environ["API_URL"]

    headers = {"x-api-key": api_key}

    response = requests.get(api_url, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")

    if 200 <= response.status_code < 300:
        sys.exit(0)
    sys.exit(response.status_code)

except KeyError as e:
    print(f"Missing environment variable: {str(e)}")
    sys.exit(1)
except requests.exceptions.RequestException as e:
    print(f"Request failed: {str(e)}")
    sys.exit(1)
