resource "aws_iam_policy" "asg_consumer" {
  name   = local.asg_consumer_policy_name
  policy = data.aws_iam_policy_document.asg_consumer.json
}

data "aws_iam_policy_document" "asg_consumer" {

  dynamic "statement" {
    for_each = length(var.asg_allowed_actions) > 0 ? [1] : []
    content {
      sid     = "AllowActionsOnASG"
      effect  = "Allow"
      actions = var.asg_allowed_actions
      resources = [
        aws_autoscaling_group.asg.arn,
      ]
    }
  }
}
