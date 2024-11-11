### Deployment Group
resource "aws_codedeploy_deployment_group" "group" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = local.codedeploy_deployment_group_name
  service_role_arn       = aws_iam_role.codedeploy_service_role.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  autoscaling_groups     = var.autoscaling_groups_names

  deployment_style {
    deployment_option = var.target_group_name != null ? "WITH_TRAFFIC_CONTROL" : "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  dynamic "load_balancer_info" {
    for_each = var.target_group_name != null ? [1] : []
    # For in-place deployments, the name of the target group that instances
    # are deregistered from, so they are not serving traffic during a deployment,
    # and then re-registered with after the deployment completes.
    content {
      target_group_info {
        name = var.target_group_name
      }
    }
  }

  dynamic "trigger_configuration" {
    for_each = var.enable_notifications ? [1] : []
    content {
      trigger_events     = ["DeploymentFailure"]
      trigger_name       = "DeploymentFailure-Notification"
      trigger_target_arn = var.notifications_sns_topic_arn
    }
  }

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }

  # Indicates what happens when new Amazon EC2 instances
  # are launched mid-deployment and do not receive
  # the deployed application revision.
  outdated_instances_strategy = var.update_outdated_instances ? "UPDATE" : "IGNORE"

  tags = var.tags
}
