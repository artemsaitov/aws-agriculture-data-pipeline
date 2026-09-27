data "archive_file" "ingestion_lambda" {
  type        = "zip"
  source_file = "${path.module}/../src/ingestion/handler.py"
  output_path = "${path.module}/ingestion_lambda.zip"
}

resource "aws_lambda_function" "ingestion" {
  function_name = "${var.project_name}-ingestion"

  filename         = data.archive_file.ingestion_lambda.output_path
  source_code_hash = data.archive_file.ingestion_lambda.output_base64sha256

  role    = aws_iam_role.ingestion_lambda.arn
  handler = "handler.lambda_handler"
  runtime = "python3.12"

  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      DATA_BUCKET_NAME = aws_s3_bucket.data.bucket
    }
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

data "archive_file" "transformation_lambda" {
  type        = "zip"
  source_file = "${path.module}/../src/transformation/handler.py"
  output_path = "${path.module}/transformation_lambda.zip"
}

resource "aws_lambda_function" "transformation" {
  function_name = "${var.project_name}-transformation"

  filename         = data.archive_file.transformation_lambda.output_path
  source_code_hash = data.archive_file.transformation_lambda.output_base64sha256

  role    = aws_iam_role.transformation_lambda.arn
  handler = "handler.lambda_handler"
  runtime = "python3.12"

  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      DATA_BUCKET_NAME = aws_s3_bucket.data.bucket
    }
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}