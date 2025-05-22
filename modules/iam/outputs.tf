output "lambda_role_arn" {
    value = aws_iam_role.iam_role_for_lambda_exec.arn
}

output "sqs_read_policy_arn" {
    value = aws_iam_policy.sqs_read_policy.arn
}

output "cloudwatch_logs_policy_arn" {
    value = aws_iam_policy.cloudwatch_logs_policy.arn
}