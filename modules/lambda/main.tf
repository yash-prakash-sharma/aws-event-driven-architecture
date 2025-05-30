/*
# TO create lambda_function.zip for changed code
data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/code"
  output_path = "${path.module}/lambda_function.zip"
}
*/

resource "aws_lambda_function" "this" {
  filename      = var.lambda_package
  function_name = var.function_name
  role          = var.lambda_role_arn
  handler       = var.handler

  source_code_hash = filebase64sha256(var.lambda_package)

  runtime = var.runtime

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_event_source_mapping" "this" {
  function_name    = var.lambda_function_arn
  event_source_arn = var.sqs_queue_arn
  enabled          = true
  batch_size       = var.batch_size

  depends_on = [
    aws_lambda_function.this,
    var.depends_on_sqs
  ]
}