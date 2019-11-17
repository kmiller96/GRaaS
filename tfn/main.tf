module "slack_messager" {
    source = "./modules/messager"
    # TODO
}

module "sms_messager" {
    source = "./modules/messager"
    # TODO
}

module "weekly_scheduler" {
    source = "./modules/scheduler"
}


module "daily_scheduler" {
    source = "./modules/scheduler"
}