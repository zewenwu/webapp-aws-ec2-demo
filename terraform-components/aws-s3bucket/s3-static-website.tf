# Static website hosting
resource "aws_s3_bucket_website_configuration" "bucket" {
  count  = var.enable_static_website_hosting ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}
