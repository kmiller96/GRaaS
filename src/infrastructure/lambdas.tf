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

resource "aws_iam_role_policy_attachment" "messager_lambda_sns_publish" {
  role       = module.messager_lambda.role_name
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

resource "aws_iam_role_policy_attachment" "formatter_lambda_s3_god_mode" {
  role       = module.formatter_lambda.role_name
  policy_arn = aws_iam_policy.s3_god_mode.arn
}


####################
## Fetcher Lambda ##
####################

resource "aws_s3_bucket" "goal_storage" {
  bucket = var.goal_bucket_name
}


module "fetcher_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-fetcher"
  lambda_package_path = "${var.build_directory}/lambdas/fetcher.zip"

  environment_variables = {
    GOAL_BUCKET = aws_s3_bucket.goal_storage.id
  }
}

resource "aws_iam_role_policy_attachment" "fetcher_lambda_s3_god_mode" {
  role       = module.fetcher_lambda.role_name
  policy_arn = aws_iam_policy.s3_god_mode.arn
}