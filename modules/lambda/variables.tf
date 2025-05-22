variable "function_name" {}
variable "lambda_role_arn" {}
variable "handler" {
  default = "index.handler"
}
variable "runtime" {}
variable "lambda_package" {}
variable "environment_variables" {
  default = {}
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function (used for event mapping)"
  type        = string
}
variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to trigger Lambda"
  type        = string
}
variable "batch_size" {
  description = "Batch size for Lambda trigger"
  type        = number
  default = 10
}
variable "depends_on_sqs" {
  description = "Optional dependency to ensure SQS is created before mapping"
}