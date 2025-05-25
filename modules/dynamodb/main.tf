resource "aws_dynamodb_table" "this" {
  name           = "${var.resource_prefix}-orders"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }
  /*
  attribute {
    name = "created_at"
    type = "S"
  }
  */
  attribute {
    name = "customer_id"
    type = "S"
  }
  /*
  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "total_amount"
    type = "N"
  }

  attribute {
    name = "shipping_address"
    type = "S"
  }
  */
  global_secondary_index {
    name               = "customer_id-index"
    hash_key           = "customer_id"
    write_capacity     = var.gsi_write_capacity
    read_capacity      = var.gsi_read_capacity
    projection_type    = "INCLUDE"
    non_key_attributes = ["status", "total_amount", "created_at"]
  }
  deletion_protection_enabled = var.deletion_protection_enabled

  tags = {
    TFSubModule = "dynamodb"
  }
}