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