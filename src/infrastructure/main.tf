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