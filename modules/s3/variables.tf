variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "prevent_destroy" {
  description = "Prevent the bucket from being destroyed"
  type        = bool
  default     = true
}
