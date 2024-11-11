### VPC
output "public_subnets_ids" {
  value = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets_ids
}

### Database
output "database_password_secret_arn" {
  value = module.database.master_password_secret_arn
}

### CodeDeploy
output "codedeploy_app_name" {
  value = module.webapp_codedeploy.app_name
}

output "codedeploy_deployment_group_name" {
  value = module.webapp_codedeploy.deployment_group_id
}

output "codedeploy_bucket_name" {
  value = module.webapp_codedeploy.s3_bucket_name
}

output "github_role_arn" {
  value = module.webapp_codedeploy.github_role_arn
}
