import json
import os
import urllib.parse

import boto3

s3 = boto3.client("s3")

DATA_BUCKET_NAME = os.environ["DATA_BUCKET_NAME"]


def transform_record(raw_data):
    current = raw_data["weather"]["current"]

    return {
        "farm_id": raw_data["farm_id"],
        "farm_name": raw_data["farm_name"],
        "source": raw_data["source"],
        "ingested_at": raw_data["ingested_at"],
        "observation_time": current["time"],
        "temperature_c": current["temperature_2m"],
        "humidity_percent": current["relative_humidity_2m"],
        "precipitation_mm": current["precipitation"],
        "wind_speed_kmh": current["wind_speed_10m"],
    }


def lambda_handler(event, context):
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        raw_key = urllib.parse.unquote_plus(
            record["s3"]["object"]["key"]
        )

        response = s3.get_object(
            Bucket=bucket,
            Key=raw_key
        )

        raw_data = json.loads(
            response["Body"].read().decode("utf-8")
        )

        processed_data = transform_record(raw_data)

        processed_key = raw_key.replace(
            "raw/",
            "processed/",
            1
        )

        s3.put_object(
            Bucket=DATA_BUCKET_NAME,
            Key=processed_key,
            Body=json.dumps(processed_data),
            ContentType="application/json"
        )

        print(
            f"Processed s3://{bucket}/{raw_key} "
            f"-> s3://{DATA_BUCKET_NAME}/{processed_key}"
        )

    return {
        "statusCode": 200,
        "body": "Transformation completed"
    }