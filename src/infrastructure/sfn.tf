resource "aws_sfn_state_machine" "sfn" {
  name     = "${var.resource_prefix}-step-function"
  role_arn = aws_iam_role.sfn.arn
  definition = templatefile(
    "${path.cwd}/src/step_function_definition.json",
    {
      fetcher_lambda_arn   = module.fetcher_lambda.lambda_arn
      formatter_lambda_arn = module.formatter_lambda.lambda_arn
      messager_lambda_arn  = module.messager_lambda.lambda_arn
    }
  )
}

resource "aws_iam_role" "sfn" {
  name               = "${var.resource_prefix}-step-function-name"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "invoke_lambdas" {
  name   = "${var.resource_prefix}-step-function-invoke-lambdas"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "sfn" {
  role       = aws_iam_role.sfn.name
  policy_arn = aws_iam_policy.invoke_lambdas.arn
}