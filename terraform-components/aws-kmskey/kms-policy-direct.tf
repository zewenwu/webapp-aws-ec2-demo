data "aws_iam_policy_document" "kms_key_policy_direct" {
  count = var.key_type == "direct" ? 1 : 0
  # Root user will have permissions to manage the CMK,
  # but do not have permissions to use the CMK in cryptographic operations.
  # https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#cryptographic-operations
  statement {
    sid = "Allow Admin"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Allow Cryptography"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    dynamic "principals" {
      for_each = var.direct_key_principal
      content {
        type        = principals.key
        identifiers = principals.value
      }
    }
  }
}
