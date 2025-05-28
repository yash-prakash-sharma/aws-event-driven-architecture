variable "resource_prefix" {
  description = "The prefix for naming resources."
  type        = string
}

variable "force_destroy" {
  description = "It indicates all objects should be deleted from the bucket when the bucket is destroyed."
  type        = bool
  default     = false
}