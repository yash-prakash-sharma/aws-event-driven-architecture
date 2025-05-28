primary_region = "us-east-1"
env            = "dev"

# dynamodb
read_capacity               = 2
write_capacity              = 2
gsi_read_capacity           = 2
gsi_write_capacity          = 2
deletion_protection_enabled = true


# sqs
queue_name                    = "event-driven-architecture-dev-queue"
delay_seconds                 = 0
visibility_timeout            = 30
max_message_size              = 100000
message_retention_seconds     = 84600
receive_wait_time_seconds     = 0
dlq_message_retention_seconds = 1209600
dlq_max_receive_count         = 3

# lambda
function_name  = "ci-event-processor"
handler        = "lambda_function.handler"
runtime        = "python3.11"
lambda_package = "../../modules/lambda/lambda_function.zip"
environment_variables = {
  ENV = "dev"
}

# s3
force_destroy = true

# event processing
batch_size = 5