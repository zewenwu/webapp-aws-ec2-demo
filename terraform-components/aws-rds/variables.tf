### RDS instance
variable "db_instance_info" {
  description = "Database instance info"
  type = object({
    instance_name     = string
    engine            = string
    engine_version    = string
    instance_class    = string
    allocated_storage = number
    port              = number
    vpc_id            = string
    subnet_ids        = list(string)
  })
  default = {
    instance_name     = "testinstance"
    engine            = "mariadb"
    engine_version    = "10.11.6"
    instance_class    = "db.t3.medium"
    allocated_storage = 100
    port              = 3306
    vpc_id            = "vpc-123"
    subnet_ids        = ["subnet-123", "subnet-456"]
  }
}

variable "allowed_actions" {
  description = "List of RDS actions which are allowed for same account principals for the consumer policy"
  type        = list(string)
  default = [
    "rds:DescribeDBInstances",
    "rds:ListTagsForResource",
    "ec2:DescribeAccountAttributes",
    "ec2:DescribeAvailabilityZones",
    "ec2:DescribeInternetGateways",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeSubnets",
    "ec2:DescribeVpcAttribute",
    "ec2:DescribeVpcs"
  ]
}

### RDS Credentials
variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "manage_master_user_password" {
  description = "Whether to manage the master user password. If set to false, a random password will be generated and stored in Secrets Manager"
  type        = bool
  default     = true
}

### RDS Security Group
variable "allow_additional_sg_ingress_ids" {
  description = "List of additional security group IDs to allow ingress traffic into the RDS instance"
  type        = list(string)
  default     = []
}

### RDS Backup
variable "db_backup_retention_period_days" {
  description = "The number of days to retain automated backups for"
  type        = number
  default     = 7
}

### RDS Recovery Procedures
variable "recover_instance_from_snapshot" {
  description = "Whether to create the RDS instance from a snapshot"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "The snapshot identifier to create the RDS instance from"
  type        = string
  default     = ""
}

### RDS Performance Insights
variable "enable_performance_insights" {
  description = "Whether to enable Performance Insights for the RDS instance"
  type        = bool
  default     = false
}

### RDS Monitoring
variable "enable_monitoring" {
  description = "Enable monitoring for the RDS instance"
  type        = bool
  default     = false
}

variable "monitoring_sns_topic_arn" {
  description = "The ARN of the SNS topic to which the monitoring for the RDS instance will be sent"
  type        = string
  default     = ""
}

### Metadata
variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys."
  type        = map(any)
  default     = {}
}
