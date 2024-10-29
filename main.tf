terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name

}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}

#  terraform {
#    backend "s3" {
#      region         = "eu-west-2"
#      bucket         = "my-terraform-state-bucket"
#      key            = "global/s3/terraform.tfstate"
#      dynamodb_table = "terraform-state-locks"
#      encrypt        = true
#    }
#  }
#-----------------------------------------------------------------

module "dms" {
  source                   = "./modules/dms"
  dms_event_subscription   = var.dms_event_subscription
  dms_replication_task     = var.dms_replication_task
  dms_endpoint             = var.dms_endpoint
  aws_dms_s3_endpoint          = var.aws_dms_s3_endpoint
  dms_replication_instance = var.dms_replication_instance


}
