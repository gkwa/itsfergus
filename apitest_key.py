import os

import requests

try:
    api_key = os.environ["API_KEY"]
    api_url = os.environ["API_URL"]

    headers = {"x-api-key": api_key}

    response = requests.get(api_url, headers=headers)
    print(response.text)

except KeyError as e:
    print(f"Missing environment variable: {str(e)}")
except requests.exceptions.RequestException as e:
    print(f"Request failed: {str(e)}")
