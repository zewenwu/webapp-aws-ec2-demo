#trivy:ignore:s3-bucket-logging
resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket_name
  force_destroy = var.force_s3_destroy

  tags = merge({
    Name = var.bucket_name
  }, var.tags)
}

# Remove ACLs
resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.enable_public_access || var.enable_static_website_hosting ? false : true
  block_public_policy     = var.enable_public_access || var.enable_static_website_hosting ? false : true
  ignore_public_acls      = var.enable_public_access || var.enable_static_website_hosting ? false : true
  restrict_public_buckets = var.enable_public_access || var.enable_static_website_hosting ? false : true
}

# Enable versioning
#trivy:ignore:avd-aws-0090
resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}
