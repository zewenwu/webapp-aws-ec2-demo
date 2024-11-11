resource "aws_iam_policy" "consumer" {
  name   = local.instance_consumer_policy_name
  policy = data.aws_iam_policy_document.consumer.json
}

data "aws_iam_policy_document" "consumer" {

  dynamic "statement" {
    for_each = length(var.allowed_actions) > 0 ? [1] : []
    content {
      sid     = "AllowActionsOnRDSInstance"
      effect  = "Allow"
      actions = var.allowed_actions
      resources = [
        aws_db_instance.database.arn,
      ]
    }
  }

  statement {
    sid    = "AllowGettingMasterUserPassword"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.manage_master_user_password ? aws_db_instance.database.master_user_secret[0].secret_arn : aws_secretsmanager_secret.master_user_credentials_secret[0].arn,
    ]
  }
}
