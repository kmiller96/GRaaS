locals {
    prefix = "graas/templates"
}


module "weekly_goal" {
    source = "./modules/file"

    local_path = "${path.module}/templates/weekly_sms.template"
    bucket = aws_s3_bucket.graas_storage.id
    key = "${local.prefix}/weekly"
}