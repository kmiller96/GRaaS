"""Sends a SMS message to the nominated number.

This lambda can only be invoked directly with the following, custom event 
structure:

{
    "address": str,
    "message": str
}

where the "address" key will, in this case, be the mobile number. The number 
format should be in international format. For an Australian number this would 
look like "+61412345678".
"""

import os

import boto3

sns = boto3.client("sns")


def lambda_handler(event, context):
    address = event["address"]
    message = event["message"]
    sender_name = os.environ["SMS_SENDER_NAME"]

    response = send_sms_message(sender=sender_name, number=address, message=message)

    return response


def send_sms_message(sender, number, message):
    return sns.publish(
        PhoneNumber=number,
        Message=message,
        MessageAttributes={
            "AWS.SNS.SMS.SenderID": {"DataType": "String", "StringValue": sender,},
            "AWS.SNS.SMS.SMSType": {
                "DataType": "String",
                "StringValue": "Promotional",
            },
        },
    )
