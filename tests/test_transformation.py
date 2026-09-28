import os
import unittest

# handler.py expects this environment variable during import
os.environ["DATA_BUCKET_NAME"] = "test-bucket"

from src.transformation.handler import (
    build_processed_key,
    transform_record,
)


class TestTransformation(unittest.TestCase):

    def setUp(self):
        self.raw_data = {
            "farm_id": "farm-indiana-001",
            "farm_name": "Indiana Farm",
            "source": "open-meteo",
            "ingested_at": "2026-09-28T01:49:00Z",
            "weather": {
                "current": {
                    "time": "2026-09-28T01:45",
                    "temperature_2m": 21.5,
                    "relative_humidity_2m": 65,
                    "precipitation": 0.0,
                    "wind_speed_10m": 8.4,
                }
            },
        }

    def test_transform_record(self):
        result = transform_record(self.raw_data)

        self.assertEqual(result["farm_id"], "farm-indiana-001")
        self.assertEqual(result["farm_name"], "Indiana Farm")
        self.assertEqual(result["source"], "open-meteo")
        self.assertEqual(result["observation_time"], "2026-09-28T01:45")
        self.assertEqual(result["temperature_c"], 21.5)
        self.assertEqual(result["humidity_percent"], 65)
        self.assertEqual(result["precipitation_mm"], 0.0)
        self.assertEqual(result["wind_speed_kmh"], 8.4)

    def test_processed_key(self):
        processed_data = transform_record(self.raw_data)

        key = build_processed_key(processed_data)

        self.assertEqual(
            key,
            "processed/farm-indiana-001/2026/09/28/"
            "20260928T0145.json",
        )

    def test_processed_key_is_idempotent(self):
        processed_data = transform_record(self.raw_data)

        first_key = build_processed_key(processed_data)
        second_key = build_processed_key(processed_data)

        self.assertEqual(first_key, second_key)


if __name__ == "__main__":
    unittest.main()