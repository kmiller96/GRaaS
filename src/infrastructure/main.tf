provider "aws" {
    region = "ap-southeast-2"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"
}


module "messager_lambda" {
  source = "./modules/lambda"

  name                = "${var.resource_prefix}-sms-messager"
  lambda_package_path = "${var.build_directory}/lambdas/messager.zip"

  environment_variables = {
    SMS_SENDER_NAME = "GRaaS"
  }
}