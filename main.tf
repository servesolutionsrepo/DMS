module "s3" {
  source          = "./modules/s3"
  bucket_name     = var.bucket_name

}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}

# terraform {
#   backend "s3" {
#     region         = "eu-west-2"
#     bucket         = "my-terraform-state-bucket"
#     key            = "global/s3/terraform.tfstate"
#     dynamodb_table = "terraform-state-locks"
#     encrypt        = true
#   }
# }