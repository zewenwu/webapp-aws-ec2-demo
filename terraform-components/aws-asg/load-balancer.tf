### Load Balancer Security Group
module "asg_lb_sg" {
  count  = var.deploy_asg_lb ? 1 : 0
  source = "../aws-sg"

  service_name               = local.asg_lb_name
  security_group_description = "Security group for the load balancer of the ASG"
  vpc_id                     = var.asg_lb_info.vpc_id

  allow_ingress_internet    = var.asg_lb_info.internal_lb ? false : true
  ingress_internet_port     = var.asg_lb_info.service_port
  ingress_internet_protocol = "tcp"

  tags = var.tags
}

### Load Balancer Target Group
resource "aws_lb_target_group" "asg_lb" {
  count       = var.deploy_asg_lb ? 1 : 0
  name        = local.asg_lb_tg_name_short
  port        = var.asg_lb_info.service_port
  protocol    = var.asg_lb_info.service_port == 443 ? "HTTPS" : (var.asg_lb_info.service_port == 80 || var.asg_lb_info.lb_type == "application" ? "HTTP" : "TCP")
  vpc_id      = var.asg_lb_info.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = var.asg_lb_health_check.interval
    healthy_threshold   = var.asg_lb_health_check.healthy_threshold
    unhealthy_threshold = var.asg_lb_health_check.unhealthy_threshold
    protocol            = var.asg_lb_info.service_port == 443 ? "HTTPS" : (var.asg_lb_info.service_port == 80 || var.asg_lb_info.lb_type == "application" ? "HTTP" : "TCP")
    timeout             = var.asg_lb_info.service_port == 443 || var.asg_lb_info.service_port == 80 || var.asg_lb_info.lb_type == "application" ? var.asg_lb_health_check.timeout : null
    path                = var.asg_lb_info.service_port == 443 || var.asg_lb_info.service_port == 80 || var.asg_lb_info.lb_type == "application" ? var.asg_lb_health_check.path : null
    matcher             = var.asg_lb_info.service_port == 443 || var.asg_lb_info.service_port == 80 || var.asg_lb_info.lb_type == "application" ? var.asg_lb_health_check.matcher : null
  }

  tags = merge({
    Name = local.asg_lb_tg_name_short
  }, var.tags)
}

### Load Balancer Listener
resource "aws_lb_listener" "nlb_listener" {
  count             = var.deploy_asg_lb && var.asg_lb_info.lb_type == "network" ? 1 : 0
  load_balancer_arn = aws_lb.asg_lb[0].arn

  port     = var.asg_lb_info.service_port
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_lb[0].arn
  }
}

resource "aws_lb_listener" "alb_listener" {
  count             = var.deploy_asg_lb && var.asg_lb_info.lb_type == "application" ? 1 : 0
  load_balancer_arn = aws_lb.asg_lb[0].arn

  port            = var.asg_lb_info.service_port
  protocol        = var.asg_lb_info.service_port == 443 ? "HTTPS" : "HTTP"
  certificate_arn = var.asg_lb_info.service_port == 443 ? var.certificate_arn : ""
  ssl_policy      = var.asg_lb_info.service_port == 443 ? "ELBSecurityPolicy-FS-1-2-Res-2019-08" : ""

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No service found"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "alb_host_based_listener" {
  count        = var.deploy_asg_lb && var.asg_alb_rule_host_based_routing.value != null ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = var.asg_alb_rule_host_based_routing.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_lb[0].arn
  }

  condition {
    host_header {
      values = [var.asg_alb_rule_host_based_routing.value == "" ? "*" : var.asg_alb_rule_host_based_routing.value]
    }
  }

  dynamic "condition" {
    for_each = var.asg_alb_custom_header_token == null ? [] : [true]
    content {
      http_header {
        http_header_name = "custom-header-token"
        values           = [var.asg_alb_custom_header_token]
      }
    }
  }
}

resource "aws_lb_listener_rule" "alb_path_based_listener" {
  count        = var.deploy_asg_lb && var.asg_alb_rule_path_based_routing.value != null ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = var.asg_alb_rule_path_based_routing.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_lb[0].arn
  }

  condition {
    path_pattern {
      values = [var.asg_alb_rule_path_based_routing.value == "" ? "*" : var.asg_alb_rule_path_based_routing.value]
    }
  }

  dynamic "condition" {
    for_each = var.asg_alb_custom_header_token == null ? [] : [true]
    content {
      http_header {
        http_header_name = "custom-header-token"
        values           = [var.asg_alb_custom_header_token]
      }
    }
  }
}

### Load Balancer
resource "aws_lb" "asg_lb" {
  count                      = var.deploy_asg_lb ? 1 : 0
  name                       = local.asg_lb_name
  load_balancer_type         = var.asg_lb_info.lb_type
  subnets                    = var.asg_lb_info.subnet_ids
  security_groups            = [module.asg_lb_sg[0].security_group_id]
  drop_invalid_header_fields = true
  enable_deletion_protection = false
  internal                   = var.asg_lb_info.internal_lb

  access_logs {
    bucket  = var.asg_lb_info.lb_access_logs_bucket
    prefix  = local.asg_lb_name
    enabled = var.asg_lb_info.lb_access_logs_bucket == "" ? false : true
  }

  tags = merge({
    Name = local.asg_lb_name
  }, var.tags)
}
