output "data_bucket_name" {
  description = "S3 bucket containing raw and processed agriculture data"
  value       = aws_s3_bucket.data.bucket
}
