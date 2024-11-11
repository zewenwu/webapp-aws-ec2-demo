### CodeDeploy
variable "service_name" {
  description = "The name of the service for which code deploy mechanisms is being created"
  type        = string
}

variable "autoscaling_groups_names" {
  description = "The names of the autoscaling groups to which the deployment group will be associated"
  type        = list(string)
}

variable "update_outdated_instances" {
  description = "Update EC2 instances that are launched mid-deployment during deployment"
  type        = bool
  default     = false
}

### Load Balancer
variable "target_group_name" {
  description = "The name of the target group to which the instances will be deregistered during deployment. This avoids serving traffic during deployment, but slows down deployment."
  type        = string
  default     = null
}

### Notifications
variable "enable_notifications" {
  description = "Enable notifications for the deployment group"
  type        = bool
  default     = false
}

variable "notifications_sns_topic_arn" {
  description = "The ARN of the SNS topic to which the notifications of the deployments will be sent"
  type        = string
  default     = ""
}

### GitHub OIDC
variable "enable_github_oidc" {
  description = "Enable GitHub OIDC for this module"
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub organization to establish The GitHub OIDC trust with"
  type        = string
  default     = "zewenwu"
}

variable "github_repo" {
  description = "GitHub repository to establish The GitHub OIDC trust with"
  type        = string
  default     = "webapp-aws-ec2-demo-private"
}

### Metadata
variable "tags" {
  description = "Tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}
