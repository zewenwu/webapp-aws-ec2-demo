# Target Tracking Scaling policy
resource "aws_autoscaling_policy" "target_tracking_scaling_policy" {
  name                      = local.asg_scaling_policy_name
  autoscaling_group_name    = aws_autoscaling_group.asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = var.dynamic_scaling_info.estimated_instance_warmup_time_seconds
  enabled                   = var.dynamic_scaling_info.enabled

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.dynamic_scaling_info.predefined_metric_type
    }
    target_value     = var.dynamic_scaling_info.target_value
    disable_scale_in = var.dynamic_scaling_info.disable_scale_in
  }
}
