### Application Scale Group
variable "asg_info" {
  description = <<EOH
The info block for the application scale group to deploy.
EOH
  type = object({
    name                  = string
    min_size_unit         = number
    max_size_unit         = number
    desired_capacity_unit = number
    subnet_ids            = list(string)

  })
  default = {
    name                  = "webapp"
    min_size_unit         = 1
    max_size_unit         = 1
    desired_capacity_unit = 1
    subnet_ids            = ["subnet-123", "subnet-abc"]
  }
}

variable "asg_allowed_actions" {
  description = "List of ASG actions which are allowed for same account principals for the consumer policy"
  type        = list(string)
  default = [
    "autoscaling:DescribeAutoScalingGroups"
  ]
}

variable "dynamic_scaling_info" {
  type = object({
    estimated_instance_warmup_time_seconds = number
    enabled                                = bool
    predefined_metric_type                 = string
    target_value                           = number
    disable_scale_in                       = bool
  })
  default = {
    estimated_instance_warmup_time_seconds = 300
    enabled                                = false
    predefined_metric_type                 = "ASGAverageCPUUtilization"
    target_value                           = 50.0
    disable_scale_in                       = false
  }
}

### ASG Launch Template
variable "launch_template_info" {
  description = <<EOH
The info block for the launch template to deploy.
For instance_role_policy_arns to attach to the Launch Template EC2 Instance Role, use for example: { rds_arn = module.postgres_db.rds_policy_arn }
EOH
  type = object({
    name                      = string
    image_id                  = string
    instance_type             = string
    vpc_id                    = string
    instance_role_policy_arns = map(string)
    block_volume_size         = number
    user_data_path            = string
  })
  default = {
    name          = "webapp"
    image_id      = "latest"
    instance_type = "t2.micro"
    vpc_id        = "vpc-123"
    instance_role_policy_arns = {
      rds_consumer = "arn:aws:iam::123456789012:policy/MyRDSConsumerPolicy"
      s3_consumer  = "arn:aws:iam::123456789012:policy/MyS3ConsumerPolicy"
    }
    block_volume_size = 10
    user_data_path    = "user-data/http-example-simple.sh"
  }
}

variable "launch_template_secrets" {
  description = "Map of secret name (as reflected in Secrets Manager) and secret JSON string associated that can be accessed by the EC2 instances of the launch template."
  type        = map(string)
  default     = {}
}

### ASG Load Balancer
variable "deploy_asg_lb" {
  description = "Whether to deploy the ASG Load Balancer or not"
  type        = bool
  default     = false
}

variable "asg_lb_info" {
  description = <<EOH
The info block for the application scale group load balancer to deploy.
If internal_lb is true, then the subnet_ids should be private subnets, else public subnets.
EOH
  type = object({
    lb_type               = string
    internal_lb           = bool
    service_port          = number
    lb_access_logs_bucket = string
    vpc_id                = string
    subnet_ids            = list(string)
  })
  default = {
    lb_type               = "application"
    internal_lb           = false
    service_port          = 80
    lb_access_logs_bucket = "bucket-123"
    vpc_id                = "vpc-123"
    subnet_ids            = ["subnet-123", "subnet-abc"]
  }
}

variable "certificate_arn" {
  description = "The ARN of the certificate to use for the load balancer"
  type        = string
  default     = ""
}

variable "asg_lb_health_check" {
  description = <<EOH
The health check block for the application scale group load balancer to deploy.
EOH
  type = object({
    interval            = number
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    path                = string
    matcher             = string
  })
  default = {
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    matcher             = "200"
  }
}

variable "asg_alb_rule_host_based_routing" {
  description = "[Optional] Mention host For ALB routing eg: some_host, specify one of host based or path based is needed for ALB listener when attach_alb is enable"
  type = object({
    priority = string
    value    = string
  })
  default = {
    priority = "100"
    value    = null
  }
}

variable "asg_alb_rule_path_based_routing" {
  description = "Mention Path For ALB routing eg: / or /route1, specify one of host based or path based is needed for ALB listener when attach_alb is enable"
  type = object({
    priority = string
    value    = string
  })
  default = {
    priority = "100"
    value    = null
  }
}

variable "asg_alb_custom_header_token" {
  description = "Specify secret value for custom header that will be added to lb listener rules"

  type    = string
  default = null
}

### ASG and ASG Load Balancer Monitoring
variable "enable_monitoring" {
  description = "Enable monitoring for the ASG and the ASG Load Balancer"
  type        = bool
  default     = false
}

variable "monitoring_sns_topic_arn" {
  description = "The ARN of the SNS topic to which the monitoring for the ASG will be sent"
  type        = string
  default     = ""
}

### Metadata
variable "tags" {
  description = "Tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(string)
  default     = {}
}
