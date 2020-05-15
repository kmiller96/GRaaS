"""Schedules the weekly notification functionality.

Once a week, I'd like to send a copy of my current monthly goals. This lambda
controls that execution flow.
"""

import os
import logging
import json

import boto3

LOGGER = logging.getLogger()
LOGGER.setLevel(os.environ.get("LOGGING_LEVEL", logging.CRITICAL))

sfn = boto3.client("stepfunctions")


def lambda_handler(event, context):
    parameters = {
        "Input": {
            "GoalType": "monthly",
            "TemplateURI": os.environ["TEMPLATE_URI"],
            "NotificationAddress": os.environ["MOBILE_NUMBER"],
        }
    }
    LOGGER.debug(f"Input to Step Function: {parameters}")

    response = sfn.start_execution(
        stateMachineArn=os.environ["STEP_FUNCTION_ARN"], input=json.dumps(parameters)
    )
    LOGGER.debug(f"Execution ARN: {response['executionArn']}")
    return
