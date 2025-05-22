terraform {
  required_version = "~> 1.11.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.98"
    }
  }
  backend "s3" {
    bucket       = "tfprojbkt140525"
    key          = "dev/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.primary_region
  default_tags {
    tags = {
      Environment = var.env
      Project     = "event-driven-architecture"
      CreatedBy   = "yash-sharma"
    }
  }
}

module "sqs" {
  source                    = "../../modules/sqs"
  queue_name                = var.queue_name
  delay_seconds             = var.delay_seconds
  visibility_timeout        = var.visibility_timeout
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
}

module "iam" {
  source         = "../../modules/iam"
  resource_prefix    = var.resource_prefix
  sqs_queue_arns = [module.sqs.queue_arn]
  primary_region         = var.primary_region
}

module "lambda" {
  source                = "../../modules/lambda"
  function_name         = var.function_name
  lambda_role_arn       = module.iam.lambda_role_arn
  runtime               = var.runtime
  handler               = var.handler
  lambda_package        = var.lambda_package
  environment_variables = var.environment_variables

  # Event source mapping inputs
  lambda_function_arn = module.lambda.lambda_function_arn
  sqs_queue_arn       = module.sqs.queue_arn
  batch_size          = var.batch_size
  depends_on_sqs      = module.sqs
}