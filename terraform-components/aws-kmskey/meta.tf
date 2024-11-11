data "aws_caller_identity" "current" {}

resource "random_string" "random_suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = false
  special = false
}

locals {
  alias_name = "${var.alias_name}${var.append_random_suffix ? "-${random_string.random_suffix.result}" : ""}"

  caller_account_condition = {
    test     = "StringEquals"
    variable = "kms:CallerAccount"
    values   = var.service_key_info.caller_account_ids
  }
  kms_conditions = length(var.service_key_info.caller_account_ids) > 0 ? setunion(var.kms_key_conditions, [local.caller_account_condition]) : var.kms_key_conditions
}
