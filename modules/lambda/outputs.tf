output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_sqs_mapping_arn" {
  description = "The event source mapping ARN"
  value = aws_lambda_event_source_mapping.this.arn
}

output "lambda_sqs_mapping_uuid" {
  description = "The UUID of the created event source mapping"
  value = aws_lambda_event_source_mapping.this.uuid
}