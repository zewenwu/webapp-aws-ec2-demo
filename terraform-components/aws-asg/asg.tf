resource "aws_autoscaling_group" "asg" {
  name                = var.asg_info.name
  vpc_zone_identifier = var.asg_info.subnet_ids

  min_size         = var.asg_info.min_size_unit
  max_size         = var.asg_info.max_size_unit
  desired_capacity = var.asg_info.desired_capacity_unit

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }

  # Load Balancer Health Check
  health_check_type         = var.deploy_asg_lb ? "ELB" : "EC2"
  health_check_grace_period = 300

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

### ASG Load Balancer Attachment
resource "aws_autoscaling_attachment" "asg_lb" {
  count                  = var.deploy_asg_lb ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.asg_lb[0].arn
}
