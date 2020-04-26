resource "aws_s3_bucket" "this" {
  bucket = "${var.resource_prefix}-graas-bucket"
}

resource "aws_sns_topic" "this" {
  name = "${var.resource_prefix}-graas-topic"
}