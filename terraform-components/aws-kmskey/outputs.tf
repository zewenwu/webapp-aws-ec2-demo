output "key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.key.arn
}

output "key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.key.key_id
}
