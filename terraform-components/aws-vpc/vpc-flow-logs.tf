### IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_log" {
  name               = local.vpc_flow_log_role_name
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_log_assume_role.json
}

data "aws_iam_policy_document" "vpc_flow_log_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name   = "VPCFlowLogPolicy"
  role   = aws_iam_role.vpc_flow_log.id
  policy = data.aws_iam_policy_document.vpc_flow_log_policy.json
}

# See: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-iam-role.html
data "aws_iam_policy_document" "vpc_flow_log_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [aws_cloudwatch_log_group.vpc_flow_log.arn]
  }
}


### VPC Flow Log Group
#trivy:ignore:avd-aws-0017
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = local.vpc_flow_log_group_name
  retention_in_days = 90

  tags = var.tags
}

### VPC Flow Log Configuration
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn         = aws_iam_role.vpc_flow_log.arn
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id

  tags = merge(
    {
      Name = local.vpc_flow_log_group_name
    },
    var.tags
  )
}
