#############################
## Weekly Scheduler Lambda ##
#############################


module "weekly_scheduler_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-weekly-scheduler"
  lambda_package_path = "${var.build_directory}/lambdas/weekly_scheduler.zip"

  environment_variables = {
    TEMPLATE_URI = "s3://${var.goal_bucket_name}/graas/templates/weekly_update.template"
    MOBILE_NUMBER = var.mobile_number
  }
}

resource "aws_iam_role_policy_attachment" "weekly_scheduler_lambda_invoke_sfn" {
  role       = module.weekly_scheduler_lambda.role_name
  policy_arn = aws_iam_policy.invoke_step_function.arn
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