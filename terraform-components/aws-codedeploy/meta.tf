locals {
  codedeploy_app_name              = "${var.service_name}-codedeploy-app"
  codedeploy_service_role_name     = "${var.service_name}-codedeploy-role"
  codedeploy_deployment_group_name = "${var.service_name}-codedeploy-deploymentgroup"
  codedeploy_bucket_name           = "${var.service_name}-codedeploy-bucket"

  codedeploy_github_role_name = "${var.service_name}-codedeploy-github-role"
}

data "tls_certificate" "github_oidc" {
  count = var.enable_github_oidc ? 1 : 0
  url   = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}
