### IAM OpenID Connect Provider for GitHub Actions
# See https://stackoverflow.com/questions/69247498/how-can-i-calculate-the-thumbprint-of-an-openid-connect-server
resource "aws_iam_openid_connect_provider" "github_oidc" {
  count           = var.enable_github_oidc ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_oidc[0].certificates[0].sha1_fingerprint]

  tags = var.tags
}
