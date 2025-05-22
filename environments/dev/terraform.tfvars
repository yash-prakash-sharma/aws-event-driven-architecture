primary_region = "us-east-1"
env            = "dev"

queue_name                = "event-driven-architecture-dev-queue"
delay_seconds             = 0
visibility_timeout        = 30
max_message_size          = 100000
message_retention_seconds = 84600
receive_wait_time_seconds = 0

function_name  = "ci-event-processor"
handler        = "lambda_function.handler"
runtime        = "python3.11"
lambda_package = "../../modules/lambda/lambda_function.zip"
environment_variables = {
  ENV = "dev"
}


batch_size = 5