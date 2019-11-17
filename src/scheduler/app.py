"""Contains the generic scheduler logic.

The concern of the scheduler lambdas are all roughly the same (they just want
to grab a file from S3, read it, and propogate it to SNS) so rather than make
many copies of the same lambda, it may as well have a single lambda source with
many AWS Step Functions invoking it.

The lambda will read in a file from S3, load it's contents (which is the goal), 
then publish the content to SNS where messager lambdas can be listening and
propogate the message through their responsible medium.

The handler function expects an event with the following schema:

```
{
    "s3_uri": "s3://<bucket>/<path>",
    "topic": "<SNS topic name>"
}
```
"""
import boto3
import re


def lambda_handler(event, context):
    goal = read_plain_text_file(event['s3_uri'])
    publish(
        topic=event['topic'],
        message="My debugging message."
    )
    return 200


def read_plain_text_file(uri, s3_resource=None):
    match = re.match(r's3:\/\/(.+?)\/(.+)', uri)
    bucket = match.group(1)
    key = match.group(2)

    s3 = boto3.resource('s3')
    obj = s3.Object(bucket_name=bucket, key=key)
    goal = (
        obj
        .get()
        ['Body']
        .read()
        .decode('utf-8')
    )
    return goal


def publish(topic, message)
    sns = boto3.client('sns')
    response = sns.create_topic(Name=event["topic"])  
    topic_arn = response['TopicArn']
    return sns.publish(
        TopicArn=topic_arn,
        Message=json.dumps({
            'message': message
        }), 
    )