### Code Deployment Service Role
resource "aws_iam_role" "codedeploy_service_role" {
  name = local.codedeploy_service_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

# Taken from https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html
# for the EC2/On-Premises deployment case
resource "aws_iam_role_policy_attachment" "codedeploy_service_role_policy_deploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_service_role.name
}

### Role for GitHub Actions for CI/CD
resource "aws_iam_role" "codedeploy_github_role" {
  count = var.enable_github_oidc ? 1 : 0
  name  = local.codedeploy_github_role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github_oidc[0].arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_org}/${var.github_repo}:*"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# Policy to allow GitHub Actions to create a deployment
resource "aws_iam_role_policy_attachment" "codedeploy_github_role_policy_deployeraccess" {
  count      = var.enable_github_oidc ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
  role       = aws_iam_role.codedeploy_github_role[0].name
}

# Policy to allow GitHub Actions to upload to the CodeDeploy S3 bucket
resource "aws_iam_role_policy_attachment" "codedeploy_github_role_policy_uploads3" {
  count      = var.enable_github_oidc ? 1 : 0
  policy_arn = module.codedeploy_bucket.consumer_policy_arn
  role       = aws_iam_role.codedeploy_github_role[0].name
}
