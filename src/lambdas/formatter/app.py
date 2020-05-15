"""Formats a message using a Jinja template definition.

Abstracts away the process of injecting parameters into a templated message. For
maximum flexibility, I've decided to use Jinja to manage all of the templating
of messages. This makes it easy to loop through formatting blocks in a 
declarative way which would be hard to derive myself from scratch.

This lambda can only be invoked directly. The expected event strucutre is:

{
    "template_s3_uri": "s3://*/*",
    "parameters": {
        "<key>": "<value>",
        ...
    }
}

Where the "parameters" key contains an object with a key-value mapping of 
all of the values to inject into the template.

The lambda will complete this request and respond with the following data
structure.

{
    "message": str
}
"""

import re

import boto3
from jinja2 import Template


s3 = boto3.resource("s3")


def lambda_handler(event, context):
    s3_uri = event["template_s3_uri"]
    injection_parameters = event["parameters"]

    template = load_template(s3_uri)
    string = template.render(**injection_parameters)

    return {"message": string}


def load_template(uri):
    bucket, key = re.match(r"s3:\/\/(.+?)/(.+)", uri).groups()

    obj = s3.Object(bucket_name=bucket, key=key)
    template_string = obj.get()["Body"].read().decode("utf-8")
    template = Template(template_string)

    return template
