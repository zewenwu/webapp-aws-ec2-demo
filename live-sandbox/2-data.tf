module "database" {
  source = "../terraform-components/aws-rds"

  db_instance_info = {
    instance_name     = "webappdb"
    engine            = "postgres"
    engine_version    = "16.3"
    instance_class    = "db.t3.micro"
    allocated_storage = 10
    port              = 5432
    vpc_id            = module.vpc.vpc_id
    subnet_ids        = module.vpc.private_subnets_ids["database"]
  }

  allowed_actions = [
    "rds:DescribeDBInstances",
    "rds:ListTagsForResource",
  ]

  db_username                     = "dbadmin"
  allow_additional_sg_ingress_ids = [module.webapp.launch_template_sg_id]

  tags = local.tags
}

#trivy:ignore:avd-aws-0086
#trivy:ignore:avd-aws-0087
#trivy:ignore:avd-aws-0091
#trivy:ignore:avd-aws-0093
module "public_media_bucket" {
  source = "../terraform-components/aws-s3bucket"

  bucket_name                   = "media-bucket-public"
  append_random_suffix          = true
  force_s3_destroy              = false
  versioning_enabled            = true
  server_access_logging_enabled = false

  apply_bucket_policy   = false
  enable_kms_encryption = false

  folder_names = ["src/"]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket"
  ]

  bucket_kms_allow_additional_principals = []

  enable_public_access          = true
  enable_static_website_hosting = false

  tags = local.tags
}

module "private_assets_bucket" {
  source = "../terraform-components/aws-s3bucket"

  bucket_name                   = "assets-bucket-private"
  append_random_suffix          = true
  force_s3_destroy              = false
  versioning_enabled            = true
  server_access_logging_enabled = false

  apply_bucket_policy   = false
  enable_kms_encryption = false

  folder_names = ["src/"]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket"
  ]

  bucket_kms_allow_additional_principals = []

  enable_public_access          = false
  enable_static_website_hosting = false

  tags = local.tags
}
