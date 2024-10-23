module "s3" {
  source          = "./modules/s3"
  bucket_name     = var.bucket_name

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
  source  = "./modules/dms"
  
    # Endpoints
  endpoints = {
    source = {
      database_name               = "test"
      endpoint_id                 = "test-dms-endpoint-tf"  # Updated to match the uploaded file
      endpoint_type               = "source"
      engine_name                 = "aurora"  # Based on the file
      username                    = "test"
      password                    = "test"
      port                        = 3306
      server_name                 = "test"
      ssl_mode                    = "none"
      tags                        = { Name = "test" }
    }

    destination = {
      database_name               = "example"
      endpoint_id                 = "donnedtipi"  # Matching S3 endpoint example in dms.tf
      endpoint_type               = "target"
      engine_name                 = "aurora"  
      username                    = "mysqlUser"
      password                    = "passwordsDoNotNeedToMatch789?"
      port                        = 3306
      server_name                 = "dms-ex-dest.cluster-abcdefghijkl.us-east-1.rds.amazonaws.com"
      ssl_mode                    = "none"
      tags                        = {
        Name = "donnedtipi"
        Update = "to-update"
        Remove = "to-remove"
      }
    }
  }



  # Instance (based on dms.tf)
  allocated_storage             = 20
  auto_minor_version_upgrade    = true
  allow_major_version_upgrade   = true
  apply_immediately             = true
  engine_version                = "3.1.4"  # Updated to match the dms.tf file
  multi_az                      = false    # Based on the dms.tf file
  preferred_maintenance_window  = "sun:10:30-sun:14:30"
  publicly_accessible           = true     # Public access as specified in the dms.tf file
  replication_instance_class    = "dms.t3.large"
  replication_instance_id       = "test"
  availability_zone             = "us-west-2c"
  kms_key_arn                   = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  

  replication_tasks = {
    cdc_ex = {
      replication_task_id       = "example-cdc"
      migration_type            = "cdc"
      replication_task_settings = file("task_settings.json")
      table_mappings            = file("table_mappings.json")
      source_endpoint_key       = "source"
      target_endpoint_key       = "destination"
      tags                      = { Task = "PostgreSQL-to-MySQL" }
    }
  }

  event_subscriptions = {
    instance = {
      name                             = "instance-events"
      enabled                          = true
      instance_event_subscription_keys = ["example"]
      source_type                      = "replication-instance"
      sns_topic_arn                    = "arn:aws:sns:us-east-1:012345678910:example-topic"
      event_categories                 = [
        "failure",
        "creation",
        "deletion",
        "maintenance",
        "failover",
        "low storage",
        "configuration change"
      ]
    }
    task = {
      name                         = "task-events"
      enabled                      = true
      task_event_subscription_keys = ["cdc_ex"]
      source_type                  = "replication-task"
      sns_topic_arn                = "arn:aws:sns:us-east-1:012345678910:example-topic"
      event_categories             = [
        "failure",
        "state change",
        "creation",
        "deletion",
        "configuration change"
      ]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
