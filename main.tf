module "s3" {
  source          = "./modules/s3"
  bucket_name     = var.bucket_name

}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "aws_dynamodb_table.this.name"
}

terraform {
  backend "s3" {
    region         = "eu-west-2"
    bucket         = "aws_s3_bucket.this.bucket"
    key            = "global/s3/terraform.tfstate"
    dynamodb_table = "aws_dynamodb_table.this.name"
    encrypt        = true
  }
}