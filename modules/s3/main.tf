resource "aws_s3_bucket" "this" {
  bucket = "${var.resource_prefix}-order-receipts"
  force_destroy = var.force_destroy
  tags = {
    TFSubModule = "s3"
  }
}


