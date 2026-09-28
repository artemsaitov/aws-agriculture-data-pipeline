resource "aws_athena_workgroup" "agriculture" {
  name          = "${var.project_name}-workgroup"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/results/"
    }
  }

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}