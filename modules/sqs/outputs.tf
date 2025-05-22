output "queue_url" {
    description = "URL for the created Amazon SQS queue"
    value = aws_sqs_queue.this.url
}

output "queue_arn" {
    description = "ARN of the SQS queue"
    value = aws_sqs_queue.this.arn
}