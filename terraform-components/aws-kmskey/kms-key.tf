resource "aws_kms_key" "key" {
  description             = var.description
  enable_key_rotation     = true
  deletion_window_in_days = var.deletion_window

  policy = var.key_type == "service" ? data.aws_iam_policy_document.kms_key_policy_via_service[0].json : data.aws_iam_policy_document.kms_key_policy_direct[0].json

  tags = merge({
    Alias = var.alias_name
  }, var.tags)
}

resource "aws_kms_alias" "key" {
  name          = "alias/${local.alias_name}"
  target_key_id = aws_kms_key.key.key_id
}
