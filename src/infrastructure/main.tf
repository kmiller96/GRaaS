provider "aws" {
    region = "ap-southeast-2"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"
}


#####################
## Messager Lambda ##
#####################


module "messager_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-sms-messager"
  lambda_package_path = "${var.build_directory}/lambdas/messager.zip"

  environment_variables = {
    SMS_SENDER_NAME = "GRaaS"
  }
}

resource "aws_iam_policy" "sns_publish" {
  name        = "${var.resource_prefix}-sns-publish"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "SNS:Publish"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "messager_lambda_sns_publish" {
  role = module.messager_lambda.role_name
  policy_arn = aws_iam_policy.sns_publish.arn
}


######################
## Formatter Lambda ##
######################


module "formatter_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-formatter"
  lambda_package_path = "${var.build_directory}/lambdas/formatter.zip"
}

resource "aws_iam_policy" "s3_god_mode" {
  name        = "${var.resource_prefix}-s3-god-mode"  # TODO: tighten up this policy.

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "formatter_lambda_s3_god_mode" {
  role = module.formatter_lambda.role_name
  policy_arn = aws_iam_policy.s3_god_mode.arn
}