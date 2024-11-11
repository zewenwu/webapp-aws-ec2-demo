
### Application Scale Group
output "asg_name" {
  description = "The name of the Auto Scaling group"
  value       = aws_autoscaling_group.asg.name
}

output "asg_arn" {
  description = "The ARN of the Auto Scaling group"
  value       = aws_autoscaling_group.asg.arn
}

### Application Scale Group Consumer policy
output "asg_consumer_policy_arn" {
  value       = aws_iam_policy.asg_consumer.arn
  description = "The Amazon Resource Name (ARN) of the IAM policy for the ASG consumer."
}

### Launch Template
output "launch_template_name" {
  description = "The name of the launch template"
  value       = aws_launch_template.template.name
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.template.id
}

output "launch_template_sg_id" {
  description = "The ID of the security group of the launch template"
  value       = module.asg_launch_template_sg.security_group_id
}

output "launch_template_iam_role_name" {
  description = "The name of the IAM role of the launch template"
  value       = aws_iam_role.launch_template.name
}

output "launch_template_iam_role_id" {
  description = "The ID of the IAM role of the launch template"
  value       = aws_iam_role.launch_template.id
}

output "launch_template_iam_instance_profile_name" {
  description = "The name of the IAM instance profile of the launch template"
  value       = aws_iam_instance_profile.launch_template.name
}

output "launch_template_iam_instance_profile_id" {
  description = "The ID of the IAM instance profile of the launch template"
  value       = aws_iam_instance_profile.launch_template.id
}

### Secret
output "secret_name" {
  description = "The name of the secret"
  value       = length(var.launch_template_secrets) > 0 ? aws_secretsmanager_secret.launch_template_secret[0].name : null
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = length(var.launch_template_secrets) > 0 ? aws_secretsmanager_secret.launch_template_secret[0].arn : null
}

### ASG Load Balancer
output "asg_lb_name" {
  description = "The name of the load balancer of the ASG"
  value       = var.deploy_asg_lb ? aws_lb.asg_lb[0].name : null
}

output "asg_lb_arn" {
  description = "The ARN of the load balancer of the ASG"
  value       = var.deploy_asg_lb ? aws_lb.asg_lb[0].arn : null
}

output "asg_lb_sg_id" {
  description = "The ID of the security group of the load balancer of the ASG"
  value       = var.deploy_asg_lb ? module.asg_lb_sg[0].security_group_id : null
}

output "asg_lb_tg_name" {
  description = "The name of the target group of the load balancer of the ASG"
  value       = var.deploy_asg_lb ? aws_lb_target_group.asg_lb[0].name : null
}

output "asg_lb_tg_arn" {
  description = "The ARN of the target group of the load balancer of the ASG"
  value       = var.deploy_asg_lb ? aws_lb_target_group.asg_lb[0].arn : null
}
