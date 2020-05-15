"""Retrieves the specified goal(s) from the persistant storage medium.

Abstracts away how goals are stored and read in the application. This lambda
can only be invoked directly and with a custom event structure as defined:

{
    "goal_type": str
}

where "goal_type" can currently only take one of the values "weekly" or 
"monthly". The response from this lambda is give in the following data structure:

{
    "goals": [
        {
            "name": str
        }
    ]
}

The goals are to be stored in an extensionless plaintext file, with each goal
within the type being separated by a newline character.
"""
import os

import boto3

s3 = boto3.resource("s3")

# NOTE: We store the keys separately from the bucket since buckets are globally unique across all of AWS.
GOAL_BUCKET = os.environ["GOAL_BUCKET"]
GOAL_S3_KEY_LOOKUP = {
    "weekly": f"graas/goals/weekly",
    "monthly": f"graas/goals/monthly",
}


def lambda_handler(event, context):
    goal_type = event["goal_type"]

    goal_obj = load_goal_from_s3(goal_type=goal_type)
    return {"goals": goal_obj}


def load_goal_from_s3(goal_type):
    try:
        obj = s3.Object(bucket_name=GOAL_BUCKET, key=GOAL_S3_KEY_LOOKUP[goal_type])
        goal_string = obj.get()["Body"].read().decode("utf-8")

    except KeyError:
        raise TypeError(
            f"An invalid goal type was passed. "
            f"Must be one of the following: {list(GOAL_S3_KEY_LOOKUP.keys())}"
        )

    else:
        goals = goal_string.split("\n")
        goal_obj = [{"name": g} for g in goals]

    return goal_obj
