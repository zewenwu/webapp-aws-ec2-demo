#trivy:ignore:avd-aws-0053
#trivy:ignore:avd-aws-0054
module "webapp" {
  source = "../terraform-components/aws-asg"

  asg_info = {
    name                  = "webapp"
    min_size_unit         = 1
    max_size_unit         = 1
    desired_capacity_unit = 1
    subnet_ids            = module.vpc.private_subnets_ids["application"]
  }

  launch_template_info = {
    name          = "webapp"
    image_id      = "latest"
    instance_type = "t2.micro"
    vpc_id        = module.vpc.vpc_id
    instance_role_policy_arns = {
      rds_consumer                   = module.database.consumer_policy_arn
      public_media_bucket_consumer   = module.public_media_bucket.consumer_policy_arn
      private_assets_bucket_consumer = module.private_assets_bucket.consumer_policy_arn
      codedeploy_bucket_consumer     = module.webapp_codedeploy.s3_bucket_consumer_policy_arn
    }
    block_volume_size = 10
    user_data_path    = "./user-data-webapp/http-example-simple.sh"
  }

  deploy_asg_lb = true
  asg_lb_info = {
    lb_type               = "application"
    internal_lb           = false
    service_port          = 80
    lb_access_logs_bucket = ""
    vpc_id                = module.vpc.vpc_id
    subnet_ids            = module.vpc.public_subnets_ids
  }

  asg_alb_rule_path_based_routing = {
    priority = "100"
    value    = ""
  }

  asg_lb_health_check = {
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/"
    matcher             = "200,201,204"
  }

  tags = local.tags
}

module "webapp_codedeploy" {
  source = "../terraform-components/aws-codedeploy"

  service_name              = "webapp"
  autoscaling_groups_names  = [module.webapp.asg_name]
  update_outdated_instances = true
  target_group_name         = null

  enable_notifications = false

  enable_github_oidc = true
  github_org         = "zewenwu"
  github_repo        = "webapp-aws-ec2-demo-private"

  tags = local.tags
}
