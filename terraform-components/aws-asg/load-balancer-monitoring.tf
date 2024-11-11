resource "aws_cloudwatch_metric_alarm" "target_connection_errors_alarm" {
  count               = var.deploy_asg_lb && var.enable_monitoring ? 1 : 0
  alarm_name          = local.asg_lb_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TargetConnectionErrorCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when the target connection errors are greater than 1 for load balancer ${aws_lb.asg_lb[0].name} with target group ${aws_lb_target_group.asg_lb[0].name}"
  actions_enabled     = true
  alarm_actions       = [var.monitoring_sns_topic_arn]

  dimensions = {
    TargetGroup  = aws_lb_target_group.asg_lb[0].arn
    LoadBalancer = aws_lb.asg_lb[0].arn
  }

  tags = var.tags
}
