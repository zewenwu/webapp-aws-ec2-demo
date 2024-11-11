resource "aws_secretsmanager_secret" "master_user_credentials_secret" {
  count                   = var.manage_master_user_password ? 0 : 1
  name                    = local.instance_master_user_credentials_secret_name
  description             = "Secret for the credentials of the RDS Instance Master Password: ${var.db_instance_info.instance_name}"
  kms_key_id              = null
  recovery_window_in_days = 30

  tags = merge({
    Name = local.instance_master_user_credentials_secret_name
  }, var.tags)
}

resource "random_password" "master_user_password" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret_version" "master_user_credentials_secret" {
  count     = var.manage_master_user_password ? 0 : 1
  secret_id = aws_secretsmanager_secret.master_user_credentials_secret[0].id
  secret_string = jsonencode({
    username = var.db_username,
    password = random_password.master_user_password.result
  })
}
