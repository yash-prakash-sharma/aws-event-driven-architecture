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

module "dynamodb" {
  source                      = "../../modules/dynamodb"
  resource_prefix             = var.resource_prefix
  read_capacity               = var.read_capacity
  write_capacity              = var.write_capacity
  gsi_read_capacity           = var.gsi_read_capacity
  gsi_write_capacity          = var.gsi_write_capacity
  deletion_protection_enabled = var.deletion_protection_enabled
}

module "sqs" {
  source                        = "../../modules/sqs"
  queue_name                    = var.queue_name
  delay_seconds                 = var.delay_seconds
  visibility_timeout            = var.visibility_timeout
  max_message_size              = var.max_message_size
  message_retention_seconds     = var.message_retention_seconds
  dlq_message_retention_seconds = var.dlq_message_retention_seconds
  dlq_max_receive_count         = var.dlq_max_receive_count
  receive_wait_time_seconds     = var.receive_wait_time_seconds
}

module "iam" {
  source          = "../../modules/iam"
  resource_prefix = var.resource_prefix
  sqs_queue_arns  = [module.sqs.queue_arn]
  primary_region  = var.primary_region
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

# OIDC
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "D89E3BD43D5D909B47A18977AA9D5CE36CEE184C"
  ]
}


resource "aws_iam_role" "github_actions" {
  name = "${var.resource_prefix}-github-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:yash-prakash-sharma/aws-event-driven-architecture:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "github_terraform_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}