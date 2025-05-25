variable "resource_prefix" {
  description = "Prefix for naming the DynamoDB table."
  type        = string
}

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
