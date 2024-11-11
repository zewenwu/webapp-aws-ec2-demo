resource "aws_s3_bucket_policy" "policy" {
  count  = var.apply_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = var.enable_public_access || var.enable_static_website_hosting ? data.aws_iam_policy_document.public_read[0].json : var.full_override_bucket_policy_document
}

data "aws_iam_policy_document" "public_read" {
  count = var.apply_bucket_policy && (var.enable_public_access || var.enable_static_website_hosting) ? 1 : 0
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    actions   = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
