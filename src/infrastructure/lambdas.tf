#############################
## Weekly Scheduler Lambda ##
#############################


module "weekly_scheduler_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-weekly-scheduler"
  lambda_package_path = "${var.build_directory}/lambdas/weekly_scheduler.zip"

  environment_variables = {
    STEP_FUNCTION_ARN = aws_sfn_state_machine.sfn.id
    TEMPLATE_URI      = "s3://${module.weekly_goal.bucket}/${module.weekly_goal.key}"
    MOBILE_NUMBER     = var.mobile_number
  }
}

resource "aws_iam_role_policy_attachment" "weekly_scheduler_lambda_invoke_sfn" {
  role       = module.weekly_scheduler_lambda.role_name
  policy_arn = aws_iam_policy.invoke_step_function.arn
}

resource "aws_cloudwatch_event_rule" "weekly_cron" {
    name = "${var.resource_prefix}-weekly-scheduler-cron"
    description = "Fires every Monday morning at 8:45am"
    schedule_expression = "cron(45 22 ? * SUN *)"
}

resource "aws_cloudwatch_event_target" "weekly_cron" {
    rule = aws_cloudwatch_event_rule.weekly_cron.name
    arn = module.weekly_scheduler_lambda.lambda_arn
}

resource "aws_lambda_permission" "cloudwatch_invoke_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = module.weekly_scheduler_lambda.lambda_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.weekly_cron.arn
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


module "fetcher_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-fetcher"
  lambda_package_path = "${var.build_directory}/lambdas/fetcher.zip"

  environment_variables = {
    GOAL_OBJ_BUCKET = aws_s3_bucket.graas_storage.id
    GOAL_OBJ_KEY = module.goals.key
  }
}

resource "aws_iam_role_policy_attachment" "fetcher_lambda_s3_god_mode" {
  role       = module.fetcher_lambda.role_name
  policy_arn = aws_iam_policy.s3_god_mode.arn
}