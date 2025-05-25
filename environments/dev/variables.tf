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

variable "resource_prefix" {
  description = "The prefix for naming resources"
  type        = string
  default     = "event-driven-architecture"
}

variable "function_name" {}
variable "runtime" {}
variable "handler" {}
variable "lambda_package" {}
variable "environment_variables" {}
variable "batch_size" {}