from diagrams import Diagram 
from diagrams.aws.compute import Lambda
from diagrams.aws.storage import S3
from diagrams.aws.integration import SNS


diagram_kwargs = dict(
    outformat = "png",
    filename = "docs/diagram",

    direction = "LR",
    show = False,
)


with Diagram("GRaaS", **diagram_kwargs) as diagram:
    pass