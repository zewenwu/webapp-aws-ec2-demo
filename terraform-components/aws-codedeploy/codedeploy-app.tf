resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = local.codedeploy_app_name

  tags = var.tags
}
