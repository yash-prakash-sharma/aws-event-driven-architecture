output "s3_bucket_name" {
  description = "Name of the bucket"
  value = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "ARN of the bucket"
  value = aws_s3_bucket.this.arn
}