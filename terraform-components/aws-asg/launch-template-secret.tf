resource "aws_secretsmanager_secret" "launch_template_secret" {
  count                   = signum(length(var.launch_template_secrets))
  name                    = local.launch_template_secret_name
  description             = "Secret for the EC2 instances of the Launch Template: ${var.launch_template_info.name}"
  kms_key_id              = null
  recovery_window_in_days = 30

  tags = merge({
    Name = local.launch_template_secret_name
  }, var.tags)
}

resource "aws_secretsmanager_secret_version" "asg_secret" {
  count         = signum(length(var.launch_template_secrets))
  secret_id     = aws_secretsmanager_secret.launch_template_secret[0].id
  secret_string = jsonencode(var.launch_template_secrets)
}
