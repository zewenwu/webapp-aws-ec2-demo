output "rds_name" {
  value       = aws_db_instance.database.identifier
  description = "The name of the RDS instance."
}

output "rds_arn" {
  value       = aws_db_instance.database.arn
  description = "The ARN of the RDS instance."
}

output "rds_address" {
  value       = aws_db_instance.database.address
  description = "The address or endpoint of the RDS instance."
}

output "rds_port" {
  value       = aws_db_instance.database.port
  description = "The port on which the RDS instance is listening."
}

output "master_password_secret_arn" {
  value       = var.manage_master_user_password ? aws_db_instance.database.master_user_secret[0].secret_arn : aws_secretsmanager_secret.master_user_credentials_secret[0].arn
  description = "The ARN of the secret containing the master user password for the RDS instance."
}

### Consumer policy
output "consumer_policy_arn" {
  value       = aws_iam_policy.consumer.arn
  description = "The ARN of the IAM policy for the consumer."
}
