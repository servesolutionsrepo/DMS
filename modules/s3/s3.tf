resource "aws_s3_bucket" "dms_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}
