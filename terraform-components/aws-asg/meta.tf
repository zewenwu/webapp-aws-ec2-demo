# Latest Amazon Linux 2 AMI
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Append random string to SM Secret names because once we tear down the infra, the secret does not actually
# get deleted right away, which means that if we then try to recreate the infra, it'll fail as the
# secret name already exists.
resource "random_string" "service_secret_random_suffix" {
  length  = 5
  special = false
}

locals {
  # ASG Consumer Policy
  asg_consumer_policy_name = "${var.asg_info.name}-asg-consumer-policy"

  # ASG Target Tracking Scaling Policy
  asg_scaling_policy_name = "${var.asg_info.name}-targettrackingscaling-policy"

  # Launch template
  asg_launch_template_iam_role_name             = "${var.launch_template_info.name}-role"
  asg_launch_template_iam_instance_profile_name = "${var.launch_template_info.name}-profile"
  launch_template_secret_name                   = "${var.launch_template_info.name}-secret-${random_string.service_secret_random_suffix.result}"

  # ASG Load Balancer
  asg_lb_name          = "${var.asg_info.name}-lb"
  asg_lb_tg_name       = "${var.asg_info.name}-lb-tg"
  asg_lb_tg_name_short = substr(local.asg_lb_tg_name, 0, min(32, length(local.asg_lb_tg_name)))

  # Monitoring
  asg_lb_alarm_name = "${local.asg_lb_tg_name_short}-connection-errors-alarm"
}
