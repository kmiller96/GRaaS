module "goals" {
    source = "./modules/file"

    local_path = var.goal_config_path
    bucket = aws_s3_bucket.graas_storage.id
    key = var.goal_bucket_key
}