### Launch Template IAM Role
resource "aws_iam_role" "launch_template" {
  name = local.asg_launch_template_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

# User specified policies
resource "aws_iam_role_policy_attachment" "launch_template_role" {
  for_each   = var.launch_template_info.instance_role_policy_arns
  role       = aws_iam_role.launch_template.id
  policy_arn = each.value
}

# SSM Managed Instance Core
resource "aws_iam_role_policy_attachment" "launch_template_role_ssm" {
  role       = aws_iam_role.launch_template.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Secrets
resource "aws_iam_policy" "launch_template_get_secret" {
  count       = signum(length(var.launch_template_secrets))
  name        = "${var.launch_template_info.name}-get-secret-policy"
  description = "IAM policy to allow the EC2 instances of the launch template to pull the created secret from SecretsManager"

  policy = data.aws_iam_policy_document.launch_template_get_secret[0].json
}

data "aws_iam_policy_document" "launch_template_get_secret" {
  count   = signum(length(var.launch_template_secrets))
  version = "2012-10-17"

  statement {
    sid     = "ServiceGetSecretValue"
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.launch_template_secret[0].arn
    ]
  }
}

resource "aws_iam_role_policy_attachment" "launch_template_get_secret" {
  count      = signum(length(var.launch_template_secrets))
  role       = aws_iam_role.launch_template.name
  policy_arn = aws_iam_policy.launch_template_get_secret[0].arn
}

### Instance Profile
resource "aws_iam_instance_profile" "launch_template" {
  name = local.asg_launch_template_iam_instance_profile_name
  role = aws_iam_role.launch_template.name

  tags = var.tags
}
