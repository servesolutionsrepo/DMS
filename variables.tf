variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Change to your preferred region
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-terraform-state-bucket"
}

variable "prevent_destroy" {
  description = "Prevent the bucket from being destroyed"
  type        = bool
  default     = false
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "terraform-state-locks"
}

variable "backend_key" {
  description = "The key for the state file in the S3 bucket"
  type        = string
  default     = "global/s3/terraform.tfstate"
}
