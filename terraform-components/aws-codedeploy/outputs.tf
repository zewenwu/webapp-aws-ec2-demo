### CodeDeploy App
output "app_id" {
  description = "The ID of the CodeDeploy app"
  value       = aws_codedeploy_app.app.id
}

output "app_name" {
  description = "The name of the CodeDeploy app"
  value       = aws_codedeploy_app.app.name
}

output "app_arn" {
  description = "The ARN of the CodeDeploy app"
  value       = aws_codedeploy_app.app.arn
}

### CodeDeploy Deployment Group
output "deployment_group_id" {
  description = "The ID of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.group.deployment_group_id
}

output "deployment_group_arn" {
  description = "The ARN of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.group.arn
}

### CodeDeploy Service Role
output "service_role_id" {
  description = "The ID of the CodeDeploy service role"
  value       = aws_iam_role.codedeploy_service_role.id
}

output "service_role_name" {
  description = "The name of the CodeDeploy service role"
  value       = aws_iam_role.codedeploy_service_role.name
}

output "service_role_arn" {
  description = "The ARN of the CodeDeploy service role"
  value       = aws_iam_role.codedeploy_service_role.arn
}

### CodeDeploy S3 Bucket
output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.codedeploy_bucket.bucket_id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.codedeploy_bucket.bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.codedeploy_bucket.bucket_arn
}

output "s3_bucket_consumer_policy_arn" {
  description = "The ARN of the consumer policy for the S3 bucket"
  value       = module.codedeploy_bucket.consumer_policy_arn
}

### CodeDeploy GitHub Role
output "github_role_id" {
  description = "The ID of the CodeDeploy GitHub role"
  value       = var.enable_github_oidc ? aws_iam_role.codedeploy_github_role[0].id : null
}

output "github_role_name" {
  description = "The name of the CodeDeploy GitHub role"
  value       = var.enable_github_oidc ? aws_iam_role.codedeploy_github_role[0].name : null
}

output "github_role_arn" {
  description = "The ARN of the CodeDeploy GitHub role"
  value       = var.enable_github_oidc ? aws_iam_role.codedeploy_github_role[0].arn : null
}
