### Launch Template Security Group
module "asg_launch_template_sg" {
  source = "../aws-sg"

  service_name               = var.launch_template_info.name
  security_group_description = "Security group for launch template: ${var.launch_template_info.name}"
  vpc_id                     = var.launch_template_info.vpc_id

  allow_ingress_internet = false

  allow_additional_sg_ingress_ids = var.deploy_asg_lb ? [module.asg_lb_sg[0].security_group_id] : []
  additional_sg_port              = var.asg_lb_info.service_port
  additional_sg_protocol          = "tcp"

  tags = var.tags
}

### Launch Template
resource "aws_launch_template" "template" {
  name          = var.launch_template_info.name
  image_id      = var.launch_template_info.image_id == "latest" ? data.aws_ami.latest.id : var.launch_template_info.image_id
  instance_type = var.launch_template_info.instance_type

  vpc_security_group_ids = [module.asg_launch_template_sg.security_group_id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = var.launch_template_info.block_volume_size
      volume_type           = "gp2"
    }
  }

  # Enforce IMDS v2
  metadata_options {
    http_tokens = "required"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.launch_template.arn
  }

  user_data = filebase64(var.launch_template_info.user_data_path)

  tag_specifications {
    resource_type = "instance"
    tags = merge({
      Name = var.launch_template_info.name
    }, var.tags)
  }
  tags = var.tags
}
