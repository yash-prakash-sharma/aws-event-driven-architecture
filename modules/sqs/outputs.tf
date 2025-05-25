output "queue_url" {
  description = "URL for the created Amazon SQS queue"
  value = aws_sqs_queue.this.url
}

output "queue_arn" {
  description = "ARN of the SQS queue"
  value = aws_sqs_queue.this.arn
}

output "dlq_arn" {
  description = "URL for the created Amazon SQS DLQ queue"
  value = aws_sqs_queue.deadletter_queue.arn
}

output "dlq_url" {
  description = "ARN of the SQS DLQ"
  value = aws_sqs_queue.deadletter_queue.url
}