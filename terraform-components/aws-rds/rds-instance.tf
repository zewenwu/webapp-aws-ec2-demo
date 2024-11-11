### RDS Instance Security Group
module "db_instance_security_group" {
  source = "../aws-sg"

  service_name               = var.db_instance_info.instance_name
  security_group_description = "Security group for RDS instance: ${var.db_instance_info.instance_name}"
  vpc_id                     = var.db_instance_info.vpc_id

  allow_ingress_internet = false

  allow_additional_sg_ingress_ids = var.allow_additional_sg_ingress_ids
  additional_sg_port              = var.db_instance_info.port
  additional_sg_protocol          = "tcp"

  tags = var.tags
}

### RDS Instance
#trivy:ignore:avd-aws-0133
#trivy:ignore:avd-aws-0176
resource "aws_db_instance" "database" {
  ### Create db_instance from snapshot
  snapshot_identifier = var.recover_instance_from_snapshot ? var.snapshot_identifier : null

  # General
  identifier          = var.db_instance_info.instance_name
  db_name             = var.db_instance_info.instance_name
  engine              = var.db_instance_info.engine
  engine_version      = var.db_instance_info.engine_version
  instance_class      = var.db_instance_info.instance_class
  storage_type        = "gp2"
  allocated_storage   = var.db_instance_info.allocated_storage
  port                = var.db_instance_info.port
  network_type        = "IPV4"
  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = true

  # Networking and Security
  db_subnet_group_name   = aws_db_subnet_group.main.id
  vpc_security_group_ids = [module.db_instance_security_group.security_group_id]

  # Encryption
  storage_encrypted = true
  kms_key_id        = null # Use default RDS key

  # Database modifications must be applied at next maintenance window
  apply_immediately           = false
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  maintenance_window          = "Sat:02:00-Sat:03:00"

  # Backups
  backup_retention_period  = var.db_backup_retention_period_days
  backup_window            = "01:00-02:00"
  delete_automated_backups = false

  # Credentials
  username                      = var.db_username
  manage_master_user_password   = var.manage_master_user_password ? true : null
  password                      = var.manage_master_user_password ? null : random_password.master_user_password.result
  master_user_secret_kms_key_id = null # Use default RDS key

  # Performance Insights
  performance_insights_enabled          = var.enable_performance_insights
  performance_insights_kms_key_id       = null
  performance_insights_retention_period = var.enable_performance_insights ? 7 : null

  # Metadata
  tags                  = var.tags
  copy_tags_to_snapshot = true
}
