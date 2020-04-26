from diagrams import Diagram, Cluster
from diagrams.aws.compute import Lambda
from diagrams.aws.storage import S3
from diagrams.aws.integration import SNS


diagram_kwargs = dict(
    outformat="png", filename="docs/diagram", direction="LR", show=False,
)


with Diagram(**diagram_kwargs) as diagram:

    with Cluster("Trigger Lambdas"):
        daily_lambda = Lambda("Daily Trigger")
        weekly_lambda = Lambda("Weekly Trigger")
    trigger_lambdas = [daily_lambda, weekly_lambda]

    goal_reader_lambda = Lambda("Goal Reader")
    goal_bucket = S3("Goals Bucket")
    sns_topic = SNS("Goal Message Topic")

    with Cluster("Messaging Lambdas"):
        sms_lambda = Lambda("SMS Lambda")
        email_lambda = Lambda("Email Lambda")
    messaging_lambdas = [sms_lambda, email_lambda]

    goal_bucket >> goal_reader_lambda >> goal_bucket
    trigger_lambdas >> goal_reader_lambda >> sns_topic >> messaging_lambdas
