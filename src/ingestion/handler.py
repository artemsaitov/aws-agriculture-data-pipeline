import json
import urllib.request
import urllib.error
from datetime import datetime, timezone

import boto3
import os

s3 = boto3.client("s3")

BUCKET_NAME = os.environ["DATA_BUCKET_NAME"]



# Agricultural locations that we want to monitor.
FARMS = [
    {
        "farm_id": "farm-indiana-001",
        "name": "Indiana Farm",
        "latitude": 39.7684,
        "longitude": -86.1581
    },
    {
        "farm_id": "farm-iowa-001",
        "name": "Iowa Farm",
        "latitude": 41.5868,
        "longitude": -93.6250
    },
    {
        "farm_id": "farm-oregon-001",
        "name": "Oregon Farm",
        "latitude": 44.9429,
        "longitude": -123.0351
    }
]


def get_weather(farm):
    """
    Retrieve current weather data from Open-Meteo.
    """

    url = (
        f"https://api.open-meteo.com/v1/forecast?"
        f"latitude={farm['latitude']}&"
        f"longitude={farm['longitude']}&"
        f"current=temperature_2m,relative_humidity_2m,"
        f"precipitation,wind_speed_10m"
    )

    try:
        with urllib.request.urlopen(url, timeout=10) as response:
            weather = json.loads(
                response.read().decode("utf-8")
            )

        return {
            "farm_id": farm["farm_id"],
            "farm_name": farm["name"],
            "ingested_at": datetime.now(timezone.utc).isoformat(),
            "source": "open-meteo",
            "weather": weather
        }

    except urllib.error.URLError as error:
        print(
            f"Failed to retrieve weather for "
            f"{farm['name']}: {error}"
        )

        return None


def save_to_s3(data):
    """
    Store the original ingestion record in the raw S3 layer.
    """

    farm_id = data["farm_id"]

    now = datetime.now(timezone.utc)

    key = (
        f"raw/{farm_id}/"
        f"{now.year}/{now.month:02d}/{now.day:02d}/"
        f"{now.strftime('%H%M%S')}.json"
    )

    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=json.dumps(data),
        ContentType="application/json"
    )

    print(f"Saved: s3://{BUCKET_NAME}/{key}")


def main():
    """
    Retrieve weather for each farm and store it in S3.
    """

    for farm in FARMS:

        data = get_weather(farm)

        if data:
            save_to_s3(data)


def lambda_handler(event, context):
    main()

    return {
        "statusCode": 200,
        "body": "Weather ingestion completed"
    }