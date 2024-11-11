### RDS status change monitoring
resource "aws_cloudwatch_event_rule" "rds_status_change_rule" {
  count       = var.enable_monitoring ? 1 : 0
  name        = local.instance_eventbridge_statuschange_rule_name
  description = "Rule to capture RDS status changes: ${var.db_instance_info.instance_name}"
  event_pattern = jsonencode({
    "source" : ["aws.rds"],
    "detail-type" : ["RDS DB Instance Event"]
  })
}

resource "aws_cloudwatch_event_target" "rds_status_change_target" {
  count     = var.enable_monitoring ? 1 : 0
  rule      = aws_cloudwatch_event_rule.rds_status_change_rule[0].name
  target_id = local.instance_eventbridge_statuschange_rule_name
  arn       = var.monitoring_sns_topic_arn
}

### RDS high CPU utilization monitoring
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  count               = var.enable_monitoring ? 1 : 0
  alarm_name          = local.instance_eventbridge_highcpu_rule_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "This metric monitors RDS CPU Utilization"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_info.instance_name
  }
  alarm_actions = [var.monitoring_sns_topic_arn]
}

resource "aws_cloudwatch_event_rule" "cpu_utilization_alarm_rule" {
  count       = var.enable_monitoring ? 1 : 0
  name        = local.instance_eventbridge_highcpu_rule_name
  description = "Rule to capture high CPU Utilization: ${var.db_instance_info.instance_name}"
  event_pattern = jsonencode({
    "source" : ["aws.cloudwatch"],
    "detail-type" : ["CloudWatch Alarm State Change"],
    "detail" : {
      "alarmName" : [aws_cloudwatch_metric_alarm.high_cpu_utilization[0].alarm_name],
      "state" : {
        "value" : ["ALARM"]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "cpu_utilization_alarm_target" {
  count     = var.enable_monitoring ? 1 : 0
  rule      = aws_cloudwatch_event_rule.cpu_utilization_alarm_rule[0].name
  target_id = local.instance_eventbridge_highcpu_rule_name
  arn       = var.monitoring_sns_topic_arn
}
