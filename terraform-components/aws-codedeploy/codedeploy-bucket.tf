### Code Deployment S3 Bucket
module "codedeploy_bucket" {
  source = "../aws-s3bucket"

  bucket_name                   = local.codedeploy_bucket_name
  append_random_suffix          = true
  force_s3_destroy              = true
  versioning_enabled            = true
  server_access_logging_enabled = false

  apply_bucket_policy = false

  folder_names = []

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket"
  ]

  tags = var.tags
}
