variable "name" {}
variable "lambda_package_path" {}

variable "runtime" { default = "python3.7" }
variable "handler" { default = "app.lambda_handler" }
variable "memory_size" { default = 128 }

variable "environment_variables" {
  type    = map
  default = { "NULL" = "NULL" } # Required to prevent error being thrown if not defined.
}