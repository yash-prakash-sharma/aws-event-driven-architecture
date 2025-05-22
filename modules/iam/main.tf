# Policy that allows AWS Lambda service to assume the role
data "aws_iam_policy_document" "lambda_assume_role_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Policy that Provides receive message, delete message, change message visibility and read attribute access to SQS queues.
data "aws_iam_policy_document" "sqs_read_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
    ]

    resources = var.sqs_queue_arns
  }
}

# Policy to allow writing to Cloudwatch logs
data "aws_iam_policy_document" "cloudwatch_logs_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:${var.primary_region}:*:*"]
  }
}

# IAM Role that Lambda will assume
resource "aws_iam_role" "iam_role_for_lambda_exec" {
  name               = "${var.resource_prefix}-lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy_doc.json
}

# IAM Policy for SQS access
resource "aws_iam_policy" "sqs_read_policy" {
    name = "${var.resource_prefix}-sqs-read"
    description = "Allow Lambda to Receive, Delete and Change visibility of SQS Messages"
    policy = data.aws_iam_policy_document.sqs_read_policy_doc.json
}

# IAM Policy for Cloudwatch Logs
resource "aws_iam_policy" "cloudwatch_logs_policy" {
    name = "${var.resource_prefix}-cloudwatch-logs"
    description = "Allow Lambda to create and watch CLoudWatch Logs"
    policy = data.aws_iam_policy_document.cloudwatch_logs_policy_doc.json
  
}


# Attach SQS read policy to Role
resource "aws_iam_role_policy_attachment" "attach_sqs_read" {
    role = aws_iam_role.iam_role_for_lambda_exec.name
    policy_arn = aws_iam_policy.sqs_read_policy.arn
}


#Attach Cloudwatch Logs Policy to role
resource "aws_iam_role_policy_attachment" "attach_cw_logs" {
    role = aws_iam_role.iam_role_for_lambda_exec.name
    policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}