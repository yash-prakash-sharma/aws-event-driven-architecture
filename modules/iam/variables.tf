variable "resource_prefix" {
  description = "The prefix for naming resources"
  type        = string
}
variable "sqs_queue_arns" {

}
variable "primary_region" {
  description = "The primary AWS region to deploy the infrastructure in"
  type        = string
}
variable "table_arn" {
  description = "AWS ARN for DynamoDB Table"
}
variable "s3_bucket_arn" {
  description = "AWS ARN for S3 Bucket"
  type        = string
}