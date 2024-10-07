module "s3_bucket" {
  source          = "./modules/s3"
  bucket_name     = var.bucket_name
  prevent_destroy = var.prevent_destroy
}

module "dynamodb_table" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}

terraform {
  backend "s3" {
    bucket         = module.s3_bucket.bucket_name
    key            = var.backend_key
    region         = var.aws_region
    dynamodb_table = module.dynamodb_table.table_name
    encrypt        = true
  }
}