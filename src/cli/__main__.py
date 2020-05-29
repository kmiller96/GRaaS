import json
import os

import boto3
import click

ROOT_DIR = os.path.split(os.path.split(os.path.dirname(os.path.abspath(__file__)))[0])[0]
CONFIG_FPATH = os.path.join(ROOT_DIR, 'config', "terraform.tfvars.json")

@click.group()
def main():
    pass


@main.command()
@click.argument("fpath")
def update(fpath):
    """Updates the goals."""
    with open(CONFIG_FPATH, 'r') as f:
        tfvars = json.load(f)
        bucket, key = tfvars["goal_bucket_name"], tfvars["goal_bucket_key"]

    s3 = boto3.client("s3")
    s3.upload_file(fpath, bucket, key)
    print(f"Done! Uploaded the file located at {fpath} to GRaaS.")
    return