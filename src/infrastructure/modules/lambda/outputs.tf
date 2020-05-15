output "role_arn" {
    value = aws_iam_role.this.arn
}

output "lambda_arn" {
    value = aws_lambda_function.this.arn
}