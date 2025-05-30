variable "primary_region" {
  description = "The primary AWS region to deploy the infrastructure in"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "The environment to deploy the infrastructure in"
  type        = string
  default     = "dev"
}

variable "resource_prefix" {
  description = "The prefix for naming resources"
  type        = string
  default     = "event-driven-architecture"
}

# dynamodb module
variable "read_capacity" {
  description = "Read capacity units for the table."
  type        = number
  default     = 1
}

variable "write_capacity" {
  description = "Write capacity units for the table."
  type        = number
  default     = 1
}

variable "gsi_read_capacity" {
  description = "Read capacity units for the global secondary index."
  type        = number
  default     = 1
}

variable "gsi_write_capacity" {
  description = "Write capacity units for the global secondary index."
  type        = number
  default     = 1
}

variable "deletion_protection_enabled" {
  description = "Write capacity units for the global secondary index."
  type        = bool
  default     = true
}

# sqs module
variable "queue_name" {}
variable "delay_seconds" {
  description = "Time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
  default     = 0
}

variable "visibility_timeout" {
  description = "Visibility timeout for the queue"
  type        = number
  default     = 30
}

variable "max_message_size" {
  description = "Limit of how many bytes a message can contain before Amazon SQS rejects it"
  type        = number
  default     = 100000
}


variable "message_retention_seconds" {
  description = "Number of seconds Amazon SQS retains a message"
  type        = number
  default     = 84600
}

variable "receive_wait_time_seconds" {
  description = "Time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
  type        = number
  default     = 0
}

variable "dlq_message_retention_seconds" {
  description = "Number of seconds Amazon SQS DLQ retains a message"
  type        = number
  default     = 1209600
}

variable "dlq_max_receive_count" {
  description = "Number of failed processing attempts to move to DLQ"
  type        = number
  default     = 3
}

# lambda module
variable "function_name" {}
variable "runtime" {}
variable "handler" {}
variable "lambda_package" {}
variable "environment_variables" {}

# s3 module
variable "force_destroy" {
  description = "It indicates all objects should be deleted from the bucket when the bucket is destroyed."
  type        = bool
  default     = false
}

variable "batch_size" {}