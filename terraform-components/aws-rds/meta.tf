# Append random string to SM Secret names because once we tear down the infra, the secret does not actually
# get deleted right away, which means that if we then try to recreate the infra, it'll fail as the
# secret name already exists.
resource "random_string" "random_suffix" {
  length  = 5
  special = false
}

locals {
  instance_subnetgroup_name                    = "${var.db_instance_info.instance_name}-rds-subnetgroup"
  instance_consumer_policy_name                = "${var.db_instance_info.instance_name}-rds-consumer-policy"
  instance_master_user_credentials_secret_name = "${var.db_instance_info.instance_name}-rds-master-user-credentials-secret-${random_string.random_suffix.result}"

  instance_eventbridge_statuschange_rule_name = "${var.db_instance_info.instance_name}-rds-eventbridge-statuschange-rule"
  instance_eventbridge_highcpu_rule_name      = "${var.db_instance_info.instance_name}-rds-eventbridge-highcpu-rule"
}
